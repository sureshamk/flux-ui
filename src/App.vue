<template>
    <div id="app">
        <div class="container-fluid">
            <div class="row">
                <div class="col-3">
                    <div class="view">
                        <div class="input-group mb-2">
                            <div class="input-group-prepend">
                                <div class="input-group-text">
                                    <i class="fa fa-search" aria-hidden="true"></i>
                                </div>
                            </div>
                            <input type="text" class="rounded-0 form-control" v-model="search"
                                   id="inlineFormInputGroup" placeholder="Search">
                        </div>
                    </div>
                    <div style="height: 800px;overflow: auto;">
                        <div class="card rounded-0" v-bind:class="{ 'text-white bg-primary': selectedItem.ID===row.ID }"

                             v-bind:key="row.ID"
                             v-for="(row,index) in filteredAndSorted" v-on:click="view(row,index)">
                            <div class="card-body">

                                <h5 class="card-title">{{row.ID}}
                                    <span
                                            v-if="row.job && Object.keys(row.job).length!==0"><span
                                            class="badge badge-pill badge-warning"> <JobStatus
                                            :status="row.job.status"></JobStatus></span></span>

                                </h5>
                                <h6 class="card-subtitle"> Namespace: {{row.namespace}}</h6>
                                <p class="m-0">Status : {{row.Status}}</p>
                                <p class="m-0">Automated <span>
                <i v-if="row.Automated" class="fa fa-check" aria-hidden="true"></i>
                <i v-else class="fa fa-times" aria-hidden="true"></i>
            </span></p>
                                <p class="m-0">
                                    Locked
                                    <span>
                <i v-if="row.Locked" class="fa fa-lock" aria-hidden="true"></i>
                <i v-else class="fa fa-unlock-alt" aria-hidden="true"></i>
            </span>
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-5" v-if="selectedItem.ID">

                    <div class="card rounded-0">
                        <div class="card-header">
                            Workload : {{selectedItem.ID}} RELEASE : {{selectedItem.Status}}
                        </div>
                        <div class="card-body">

                            <div class="actions">
                                <button v-bind:disabled="selectedItem.isActionProgress"
                                        class="btn btn-primary m-1" type="button"
                                        v-on:click="toggleAction('automate')">
                                    {{!selectedItem.Automated ? 'Automate':'DeAutomate'}}
                                </button>
                                <button v-bind:disabled="selectedItem.isActionProgress"
                                        v-on:click="toggleAction('lock')"
                                        class="btn btn-primary m-1">
                                    {{!selectedItem.Locked ? 'Lock':'Unlock'}}
                                </button>
                                <button type="button" v-bind:disabled="selectedItem.isActionProgress"
                                        v-on:click="toggleAction('release')"
                                        class="btn btn-primary m-1">
                                    release
                                </button>
                                <button type="button" v-bind:disabled="selectedItem.isActionProgress"
                                        v-on:click="toggleAction('sync')"
                                        class="btn btn-primary m-1">
                                    Sync
                                </button>
                            </div>

                            <table class="table table-hover table-responsive">
                                <thead>
                                <tr>
                                    <th>Container</th>
                                    <th>Image</th>
                                </tr>
                                </thead>
                                <tbody>
                                <tr v-bind:key="index"
                                    v-for="(container,index) in selectedItem.Containers">
                                    <th>{{container.Name}}</th>
                                    <td>{{container.Current.ID}}</td>
                                </tr>
                                </tbody>
                            </table>


                            <h6>Policies </h6>
                            <table class="table table-hover"
                                   v-if="Object.keys(selectedItem.Policies).length!==0">
                                <thead>
                                <tr>
                                    <th>Name</th>
                                    <th>Policy</th>
                                </tr>
                                </thead>
                                <tbody>
                                <tr v-bind:key="index"
                                    v-for="(policy,index) in selectedItem.Policies">
                                    <th>{{index}}</th>
                                    <th>{{policy}}</th>
                                </tr>
                                </tbody>
                            </table>
                            <hr>
                            <button v-on:click="getImages">
                                Show Images
                            </button>
                            <!--                            <pre>{{selectedItem}}</pre>-->
                            <template v-if="selectedItem.listImages">
                                <ListImages v-bind:images="selectedItem.listImages"></ListImages>
                            </template>
                        </div>

                        <div class="card-footer text-muted">

                        </div>
                    </div>
                </div>
                <div class="col-4" v-if="actionType">

                    <form>
                        <div v-if="actionType==='release'">
                            <div class="form-group">
                                <label for="formGroupExampleInput33">Type</label>
                                <select id="formGroupExampleInput33" v-model="release.imageType" class="form-control"
                                        name="">
                                    <option value="<all latest>">All images</option>
                                    <option value="selective">Selective Images</option>
                                </select>
                            </div>
                            <div class="form-group" v-if="release.imageType==='selective'">
                                <label for="formGroupExampleInput44">Image</label>
                                <input type="text" class="form-control" id="formGroupExampleInput44"
                                       placeholder="User for this action" v-model="release.image">
                            </div>

                            <div class="form-group">

                                <label for="formGroupExampleInput33"> Force Update </label>
                                <br>

                                <div class="form-check form-check-inline">
                                    <input v-model="release.force" class="form-check-input" type="radio"
                                           name="inlineRadioOptions" id="inlineRadio2"
                                           value="false">
                                    <label class="form-check-label" for="inlineRadio2">No</label>
                                </div>
                                <div class="form-check form-check-inline">
                                    <input v-model="release.force" class="form-check-input" type="radio"
                                           name="inlineRadioOptions" id="inlineRadio1"
                                           value="true">
                                    <label class="form-check-label" for="inlineRadio1">Yes</label>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="formGroupExampleInput">Message</label>
                            <textarea class="form-control" id="formGroupExampleInput"
                                      placeholder="Message" v-model="cause.Message"></textarea>
                        </div>
                        <div class="form-group">
                            <label for="formGroupExampleInput2">User</label>
                            <input type="text" class="form-control" id="formGroupExampleInput2"
                                   placeholder="User for this action" v-model="cause.User">
                        </div>
                        <button v-if="actionType==='release'" type="button"
                                v-bind:disabled="selectedItem.isActionProgress"
                                v-on:click="action(selectedItem,'release')"
                                class="btn btn-primary m-1">
                            Apply
                        </button>
                        <button v-if="actionType==='sync'" type="button"
                                v-bind:disabled="selectedItem.isActionProgress"
                                v-on:click="action(selectedItem,'sync')"
                                class="btn btn-primary m-1">
                            Apply
                        </button>

                        <button v-if="actionType==='lock'" v-bind:disabled="selectedItem.isActionProgress"
                                v-on:click="action(selectedItem,!selectedItem.Locked ? 'lock':'unlock')"
                                class="btn btn-primary m-1">
                            {{!selectedItem.Locked ? 'Lock':'Unlock'}}
                        </button>
                        <button v-if="actionType==='automate'" v-bind:disabled="selectedItem.isActionProgress"
                                class="btn btn-primary m-1" type="button"
                                v-on:click="action(selectedItem,!selectedItem.Automated ? 'automate':'deautomate')">
                            {{!selectedItem.Automated ? 'Automate':'DeAutomate'}}
                        </button>

                    </form>
                    <div class="alert " v-bind:class="{
                    'alert-danger':selectedItem.job.status==='failed',
                    'alert-info':selectedItem.job.status==='success',
                    'alert-warning':selectedItem.job.status==='skipped',
                    }"
                         v-if="selectedItem.job && Object.keys(selectedItem.job).length!==0">
                        <JobStatus :status="selectedItem.job.status"></JobStatus>
                        (<i> {{selectedItem.job.status}} </i>)
                        <strong>Release: </strong> {{selectedItem.job.release}}
                        <strong>Action: </strong> {{selectedItem.job.action}}
                        <p v-if="selectedItem.job.result && selectedItem.job.result.Err">
                            {{selectedItem.job.result.Err}}
                        </p>
                        <!--                        <pre>{{selectedItem}}</pre>-->
                    </div>
                </div>
            </div>
        </div>

    </div>

</template>

<script>
  import axios from 'axios';
  import JobStatus from './components/JobStatus';
  import ListImages from './components/ListImages';

  export default {
    name: 'app',
    data: function () {
      return {
        namespaces: null,
        selectedItem: {},
        jobs: [],
        rows: [],
        actions: {
          type: '',
          label: ''
        },
        actionType: null,
        search: '',
        cause: {
          Message: '',
          User: ''
        },
        release: {
          force: 'false',
          imageType: '<all latest>'
        }
      };
    },
    components: {
      JobStatus,
      ListImages
    },
    methods: {
      view (row) {
        this.selectedItem.isActionProgress = false;
        this.selectedItem = row;
        this.$set(this.rows, this.getIndex(row.ID), this.selectedItem);
      },
      toggleAction (action) {
        this.actionType = action;
      },
      fetchData () {
        let self = this;
        axios.get('/api/flux/v6/services')
          .then(function (response) {
            // eslint-disable-next-line no-console
            console.log('response', response.data);

            var filtered = response.data.filter(function (number) {
              return number.Antecedent === '';
            });
            filtered = filtered.filter(function (number) {
              return number.ReadOnly !== 'NotInRepo';
            });
            var namespaces = filtered.map(function (data) {
              let idAndRelease = data.ID.split(/[:/]+/);
              data.meta = {
                id: data.ID,
                namespace: idAndRelease[0],
                type: idAndRelease[1],
                name: idAndRelease[2]
              };
              data.namespace = idAndRelease[0];
              // eslint-disable-next-line no-console
              // console.log('idAndRelease', data);
              return data;
            });

            // eslint-disable-next-line no-console
            console.log('namespaces', namespaces);

            self.rows = filtered;
            // eslint-disable-next-line no-console
            console.log(response.data, self.rows);
            // self.total_rows = response.data.total;
          })
          .catch(function (error) {
            // eslint-disable-next-line no-console
            console.log(error);
          });
      },
      getImages () {
        axios.get('/api/flux/v10/images?containerFields=&namespace=&service=' + this.selectedItem.ID)
          .then((response) => {
            let data = this.selectedItem;
            data.listImages = response.data[0].Containers;
            // eslint-disable-next-line no-console
            console.log('Imagesssss', response.data, this.selectedItem.listImages);

            this.$set(this.rows, this.getIndex(this.selectedItem.ID), data);

          })
          .catch(function (error) {
            // eslint-disable-next-line no-console
            console.log(error);
          });
      },
      action (release, action) {
        // eslint-disable-next-line no-console
        console.log(action);
        let self = this;
        let data = {
          'type': 'policy',
          'cause': this.cause,
          'spec': {}
        };
        if (action === 'automate') {
          data.spec[release.ID] = {
            'add': { 'automated': 'true' },
          };
        } else if (action === 'deautomate') {
          data.spec[release.ID] = {
            'remove': {
              'automated': 'true'
            }
          };
        } else if (action === 'lock') {
          data.spec[release.ID] = {
            'add': {
              'locked': 'true',
              'locked_msg': this.cause.Message,
              'locked_user': this.cause.User,
            },
            'remove': {}
          };
        } else if (action === 'unlock') {
          data.spec[release.ID] = {
            'remove': {
              'locked': 'true',
              'locked_msg': this.cause.Message,
              'locked_user': this.cause.User,
            },
            'add': {}
          };
        } else if (action === 'release') {
          data.type = 'image';
          data.spec = {
            'ServiceSpecs': [release.ID],
            'ImageSpec': this.getReleaseInfo.ImageSpec,
            'Kind': 'execute',
            'Excludes': null,
            'Force': this.getReleaseInfo.Force
          };
        } else if (action === 'sync') {
          data.type = 'sync';
          data.spec = {};
        }
        release.isActionProgress = !release.isActionProgress;
        self.$set(self.rows, this.getIndex(release.ID), release);
        axios.post('/api/flux/v9/update-manifests', data)
          .then((response) => {
            release.job = {
              id: response.data,
              action: action,
              status: 'running'
            };
            self.$set(self.rows, this.getIndex(release.ID), release);
            self.job(release);
            // eslint-disable-next-line no-console
            console.log(self.rows);
          })
          .catch((error) => {
            // eslint-disable-next-line no-console
            console.log(error);
          });
      },
      job (release) {
        let self = this;
        axios.get('/api/flux/v6/jobs?id=' + release.job.id)
          .then((response) => {
            // eslint-disable-next-line no-console
            let responseData = response.data;
            release.job.result = response.data;
            let status = 'running';

            self.$set(self.rows, this.getIndex(release.ID), release);
            if (responseData.StatusString === 'failed') {
              release.job.status = responseData.StatusString;
            } else if (responseData.StatusString === 'running' || responseData.StatusString === 'queued') {
              self.job(release);
              release.job.status = responseData.StatusString;
            } else {
              status = 'success';
              if (responseData.Result.result && responseData.Result.result.Status === 'skipped') {
                status = 'skipped';
              }
              if (this.actionType === 'sync') {
                release.job.status = status;
              }
              if (status === 'success') {

                if (responseData.Result.result && responseData.Result.result[release.ID]) {
                  status = responseData.Result.result[release.ID].Status;
                }

                if (status !== 'skipped') {
                  if (release.job.action === 'automate' || release.job.action === 'deautomate') {
                    release.Automated = !release.Automated;

                  }
                  if (release.job.action === 'lock' || release.job.action === 'unlock') {
                    release.Locked = !release.Locked;

                  }
                }
                if (responseData.Result.result && responseData.Result.result[release.ID]) {
                  release.job.status = responseData.Result.result[release.ID].Status;
                }

              }

            }
            // eslint-disable-next-line no-console
            console.log('Satt', status);
            if (status === 'success' || status === 'skipped' || responseData.StatusString === 'failed') {
              release.isActionProgress = !release.isActionProgress;
              self.$set(self.rows, this.getIndex(release.ID), release);
            }
          })
          .catch(function (error) {
            // eslint-disable-next-line no-console
            console.log(error);
          });
      },
      getIndex (releaseId) {
        return this.rows.findIndex(element => element.ID === releaseId);
      }
    },
    mounted () {
      axios.defaults.baseURL = this.base_api;
      this.fetchData();
    },
    computed: {
      filteredAndSorted () {
        function compare (a, b) {
          if (a.name < b.name) return -1;
          if (a.name > b.name) return 1;
          return 0;
        }

        return this.rows.filter(row => {
          return row.ID.toLowerCase().includes(this.search.toLowerCase());
        }).sort(compare);
      },
      getAlertClass () {
        // eslint-disable-next-line no-console
        console.log('DDDDDD', this.selectedItem.job.status);
        if (this.selectedItem.job.status === 'failed') {
          return 'alert-danger ';

        }
        return 'alert-info ';
      },
      getReleaseInfo () {
        return {
          'ImageSpec': this.release.imageType === '<all latest>' ? '<all latest>' : this.release.image,
          'Force': this.release.force === 'true'
        };
      }
    }
  };
</script>

<style>
    #app {
        font-family: 'Avenir', Helvetica, Arial, sans-serif;
        -webkit-font-smoothing: antialiased;
        -moz-osx-font-smoothing: grayscale;
        /*text-align: center;*/
        color: #2c3e50;
        /*margin-top: 60px;*/
    }
</style>