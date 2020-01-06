<template>
    <div id="app">
        <div class="container">
            <div class="row">
                <div class="col-4">
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
                <div class="col-8" v-if="selectedItem.ID">

                    <div class="card rounded-0">
                        <div class="card-header">
                            Workload : {{selectedItem.ID}} RELEASE : {{selectedItem.Status}}
                        </div>
                        <div class="card-body">


                            <div class="actions">


                                <button v-bind:disabled="selectedItem.isActionProgress" v-if="!selectedItem.Automated"
                                        class="btn btn-primary m-1" type="button"
                                        v-on:click="action(selectedItem,'automate')">


                                    Automate
                                </button>
                                <button type="button" v-bind:disabled="selectedItem.isActionProgress" v-else
                                        class="btn btn-primary m-1"
                                        v-on:click="action(selectedItem,'deautomate')">
                                    Deautomate
                                </button>


                                <button v-bind:disabled="selectedItem.isActionProgress" v-if="!selectedItem.Locked"
                                        v-on:click="action(selectedItem,'lock')"
                                        class="btn btn-primary m-1">
                                    Lock
                                </button>
                                <button type="button" v-bind:disabled="selectedItem.isActionProgress" v-else
                                        class="btn btn-primary m-1" v-on:click="action(selectedItem,'lock')">
                                    Unlock
                                </button>
                                <button type="button" v-bind:disabled="selectedItem.isActionProgress"
                                        class="btn btn-primary m-1">
                                    release
                                </button>

                            </div>

                            <div class="alert alert-info alert-dismissible"
                                 v-if="selectedItem.job && Object.keys(selectedItem.job).length!==0">
                                <JobStatus :status="selectedItem.job.status"></JobStatus>
                                (<i> {{selectedItem.job.status}} </i>)
                                <strong>Release: </strong> {{selectedItem.job.release}}
                                <strong>Action: </strong> {{selectedItem.job.action}}
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


                            <p>Policies :

                            <pre v-if="Object.keys(selectedItem.Policies).length!==0">{{selectedItem.Policies}}</pre>


                            </p>
                            <table class="table table-hover table-responsive"
                                   v-if="Object.keys(selectedItem.Policies).length!==0">
                                <thead>
                                <!--                                <tr>-->
                                <!--                                    <th>Container</th>-->
                                <!--                                    <th>Image</th>-->
                                <!--                                </tr>-->
                                </thead>
                                <tbody>
                                <tr v-bind:key="index"
                                    v-for="(policy,index) in selectedItem.Policies">
                                    <th>{{index}}</th>
                                    <th>{{policy}}</th>
                                    <!--                                    <td>{{container.Current.ID}}</td>-->
                                </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="card-footer text-muted">

                        </div>
                    </div>
                </div>
            </div>
        </div>

    </div>

</template>

<script>
  import axios from 'axios';
  import JobStatus from './components/JobStatus';

  export default {
    name: 'app',
    data: function () {
      return {
        namespaces: null,
        selectedItem: {},
        jobs: [],
        rows: [],
        search: 'tail'
      };
    },
    components: {
      JobStatus
    },
    methods: {
      view (row) {
        this.selectedItem.isActionProgress = false;
        this.selectedItem = row;
        this.$set(this.rows, this.getIndex(row.ID), this.selectedItem);
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
      action (release, action) {
        let self = this;
        let data = {
          'type': 'policy',
          'cause': {
            'Message': 'Test',
            'User': 'Suresh <suresh@tricog.com>'
          },
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
              'locked_msg': '',
              'locked_user': 'Suresh \u003csuresh@tricog.com\u003e'
            },
            'remove': {}
          };
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
            console.log('job', response.data, self.rows);
            let responseData = response.data;
            release.job.result = response.data;
            self.$set(self.rows, this.getIndex(release.ID), release);
            if (responseData.StatusString === 'running' || responseData.StatusString === 'queued') {
              self.job(release);
              release.job.status = responseData.StatusString;
            } else {
              release.isActionProgress = !release.isActionProgress;
              if (response.data.Result.result[release.ID].Status === 'success') {
                if (release.job.action === 'automate' || release.job.action === 'deautomate') {
                  release.Automated = !release.Automated;

                }
                if (release.job.action === 'lock' || release.job.action === 'unlock') {
                  release.Locked = !release.Locked;

                }
              }

              release.job.status = response.data.Result.result[release.ID].Status;
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