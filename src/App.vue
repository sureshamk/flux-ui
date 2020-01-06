<template>
    <div id="app">
        <div class="alert alert-info alert-dismissible" v-bind:key="job.id" v-for="job in jobs">
            <a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>
            <i v-if="job.status=='running'" class="fa fa-refresh fa-spin" style="font-size:15px"></i>
            <i v-if="job.status=='done'" class="fa fa-check" style="font-size:15px;color: green"></i>
            <i v-if="job.status=='skipped'" class="fa fa-exclamation-circle" style="font-size:15px;color: #e39200"></i>
            (<i> {{job.status}} </i>)
            <strong>Release: </strong> {{job.release}}
            <strong>Action: </strong> {{job.action}}
        </div>
        <v-client-table :data="rows" :columns="columns" :options="options">
            <span slot="Action" slot-scope="props">
                <a v-if="!props.row.Automated" target="_blank" :href="props.row.uri" class="btn btn-primary"
                   v-on:click="automate(props.row.ID)">
                Automate
            </a>
                <a v-else target="_blank" :href="props.row.uri" class="btn btn-primary"
                   v-on:click="deAutomate(props.row.ID)">
                Deautomate
            </a>
                <a v-if="!props.row.Locked" target="_blank" v-on:click="greet()" :href="props.row.uri"
                   class="btn btn-primary">
                Lock
            </a>
                <a v-else target="_blank" :href="props.row.uri" class="btn btn-primary">
                Unlock
            </a>
                <a target="_blank" :href="props.row.uri" class="btn btn-primary">
                release
            </a>
            </span>

            <span slot="Locked" slot-scope="props">
<!--                {{props.row.Locked.toString()}}-->
                <i v-if="props.row.Locked" class="fa fa-lock" aria-hidden="true"></i>
                <i v-else class="fa fa-unlock-alt" aria-hidden="true"></i>
            </span>
            <span slot="Automated" slot-scope="props">
<!--                {{props.row.Automated.toString()}}-->
                <i v-if="props.row.Automated" class="fa fa-check" aria-hidden="true"></i>
                <i v-else class="fa fa-times" aria-hidden="true"></i>
            </span>
            <!--            <span slot="Status" slot-scope="props">-->
            <!--                {{props.row.Status.toString()}}-->
            <!--                <i v-if="props.row.Status" class="fa fa-check" aria-hidden="true"></i>-->
            <!--                <i v-else class="fa fa-times" aria-hidden="true"></i>-->

            <!--            </span>-->
            <div slot="child_row" slot-scope="props">
                The link to {{props.row.Policies}} is <a :href="props.row.uri">{{props.row.uri}}</a>
            </div>

        </v-client-table>
    </div>

</template>

<script>
  import axios from 'axios';

  export default {
    name: 'app',
    data: function () {
      return {
        namespaces: null,
        jobs: [],
        rows: [],
        columns: [
          'ID',
          // 'Antecedent',
          'Containers',
          'namespace',
          'Status',
          // 'Ignore',
          // 'SyncError',
          // 'Antecedent',
          // 'ReadOnly',
          'Automated',
          'Locked',
          // 'Policies',
          'Action'

        ],
        options: {
          // childRow: 'ContainerInfo',
          orderBy: {
            column: 'ID'
          },
          filterable: [
            'ID',
            // 'Release',
            // 'Status',
            // 'Automated',
            // 'Locked',
            // 'Ignore',
            // 'SyncError',
            // 'Antecedent',
            // 'ReadOnly',
            'Containers'
          ],
          responseAdapter ({ data }) {
            return {
              data,
              count: data.length
            };
          },
          headings: {
            'ID': 'WORKLOAD'
          },
          templates: {
            Containers (h, row) {

              return row.Containers[0].Current.ID;
            },
            Action (h, row) {
              return row.Containers[0].Current.ID;
            },
            Automated (h, row) {
              return row.Automated;
            },
            Locked (h, row) {
              return row.Locked;
            },
            Policies (h, row) {
              return JSON.stringify(row.Policies);
            },

          }
        },

      };
    },
    components: {},
    actions: {
      increment () {
        alert(123);
      }
    },
    methods: {
      greet () {
        const swalWithBootstrapButtons = this.$swal.mixin({
          customClass: {
            confirmButton: 'btn btn-success',
            cancelButton: 'btn btn-danger'
          },
          buttonsStyling: false
        });
        this.$swal({
          title: 'Are you sure?',
          text: 'You won\'t be able to revert this!',
          icon: 'warning',
          showCancelButton: true,
          confirmButtonText: 'Yes, delete it!',
          cancelButtonText: 'No, cancel!',
          reverseButtons: true
        }).then((result) => {
          if (result.value) {
            axios.get('/api/flux/v6/services', {
              // params: {
              //   'queryParams': this.queryParams,
              //   'page': this.queryParams.page
              // }
            })
              .then(function (response) {
                swalWithBootstrapButtons.fire(
                  'Deleted!',
                  'Your file has been deleted.',
                  'success'
                );
                var filtered = response.data.filter(function (number) {
                  return number.Antecedent === '';
                });

                // console.log(filtered)

                self.rows = filtered;
                // eslint-disable-next-line no-console
                console.log(response.data, self.rows);
                // self.total_rows = response.data.total;
              })
              .catch(function (error) {
                // eslint-disable-next-line no-console
                console.log(error);
              });

          } else if (
            /* Read more about handling dismissals below */
            result.dismiss === this.$swal.DismissReason.cancel
          ) {
            swalWithBootstrapButtons.fire(
              'Cancelled',
              'Your imaginary file is safe :)',
              'error'
            );
          }
        });

      },
      onChangeQuery (queryParams) {
        this.queryParams = queryParams;
        this.fetchData();
      },
      fetchData () {
        let self = this;

        axios.get('/api/flux/v6/services', {
          // params: {
          //   'queryParams': this.queryParams,
          //   'page': this.queryParams.page
          // }
        })
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
      automate (release) {
        let self = this;
        let data = {
          'type': 'policy',
          'cause': {
            'Message': 'Test',
            'User': 'Suresh <suresh@tricog.com>'
          },
          'spec': {}
        };
        data.spec[release] = {
          'add': { 'automated': 'true' },
        };

        axios.post('//api/flux/v9/update-manifests', data)
          .then(function (response) {
            let jobData = {
              id: response.data,
              release,
              action: 'automate',
              status: 'running'
            };
            self.job(jobData);
            self.jobs.push(jobData);
            // eslint-disable-next-line no-console
            console.log(response.data, self.rows);
            // self.total_rows = response.data.total;
            // self.fetchData();

          })
          .catch(function (error) {
            // eslint-disable-next-line no-console
            console.log(error);
          });
      },
      action (release) {
        let self = this;
        let data = {
          'type': 'policy',
          'cause': {
            'Message': 'Test',
            'User': 'Suresh <suresh@tricog.com>'
          },
          'spec': {}
        };
        data.spec[release] = {
          'add': { 'automated': 'true' },
        };

        axios.post('/api/flux/v9/update-manifests', data)
          .then(function (response) {
            let jobData = {
              id: response.data,
              release,
              action: 'automate',
              status: 'running'
            };
            self.job(jobData);
            self.jobs.push(jobData);
            // eslint-disable-next-line no-console
            console.log(response.data, self.rows);
            // self.total_rows = response.data.total;
            // self.fetchData();

          })
          .catch(function (error) {
            // eslint-disable-next-line no-console
            console.log(error);
          });
      },
      deAutomate (release) {
        let self = this;
        let data = {
          'type': 'policy',
          'cause': {
            'Message': 'Test',
            'User': 'Suresh <suresh@tricog.com>'
          },
          'spec': {}
        };
        data.spec[release] = {
          'remove': {
            'automated': 'true'
          }
        };

        axios.post('/api/flux/v9/update-manifests', data)
          .then(function (response) {
            self.rows = response.data;
            // self.fetchData();
            // eslint-disable-next-line no-console
            console.log(response.data, self.rows);
            // self.total_rows = response.data.total;
          })
          .catch(function (error) {
            // eslint-disable-next-line no-console
            console.log(error);
          });
      },
      lock (release) {
        let self = this;
        let data = {
          'type': 'policy',
          'cause': {
            'Message': 'Test',
            'User': 'Suresh <suresh@tricog.com>'
          },
          'spec': {}
        };
        data.spec[release] = {
          'add': {
            'locked': 'true',
            'locked_msg': '',
            'locked_user': 'Suresh \u003csuresh@tricog.com\u003e'
          },
          'remove': {}
        };

        axios.post('/api/flux/v9/update-manifests', data)
          .then(function (response) {
            self.rows = response.data;
            self.fetchData();
            // eslint-disable-next-line no-console
            console.log(response.data, self.rows);
            // self.total_rows = response.data.total;
          })
          .catch(function (error) {
            // eslint-disable-next-line no-console
            console.log(error);
          });
      },
      job (job) {
        let self = this;
        axios.get('/api/flux/v6/jobs?id=' + job.id)
          .then(function (response) {
            // eslint-disable-next-line no-console
            console.log('job', response.data, self.rows);
            let responseData = response.data;
            if (responseData.StatusString === 'running') {
              self.job(job);
            } else {
              let jobId = job.id;
              const search = self.jobs.findIndex(element => element.id === jobId);
              let currentJob = self.jobs[search];
              currentJob.status = 'skipped';
              self.$set(self.jobs, search, currentJob);
              // search.process = 'done    ';
              // eslint-disable-next-line no-console
              console.log('job', search, jobId);
            }

            // self.total_rows = response.data.total;
          })
          .catch(function (error) {
            // eslint-disable-next-line no-console
            console.log(error);
          });
      },
    },
    mounted () {
      axios.defaults.baseURL = this.base_api ;
      this.fetchData();
    },
  };

  // /tmp/gor --input-raw :3030 --output-stdout
  // /tmp/gor --input-raw :3030 --output-file=requests.gor
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

    .VueTables__child-row-toggler {
        width: 16px;
        height: 16px;
        line-height: 16px;
        display: block;
        margin: auto;
        text-align: center;
    }

    .VueTables__child-row-toggler--closed::before {
        content: "+";
    }

    .VueTables__child-row-toggler--open::before {
        content: "-";
    }
</style>

<!--https://cloud.weave.works/api/app/autumn-paper-03/api/flux/v10/images?containerFields=Name%2CAvailable&service=contact%3Adeployment%2Fhydro2-->
<!--https://cloud.weave.works/api/app/autumn-paper-03/api/flux/v6/history?limit=20&service=contact%3Adeployment%2Fhydro2-->
<!--https://cloud.weave.works/api/app/autumn-paper-03/api/flux/v6/policies?user=weave%20weave%20%3Cweave345%40yopmail.com%3E-->
<!--{"contact:deployment/hydro2":{"add":{"tag.hydro2":"glob:d38e5*"}}}-->