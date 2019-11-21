<template>
    <div id="app">

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
            <div slot="child_row" slot-scope="props">
                The link to {{props.row.Containers}} is <a :href="props.row.uri">{{props.row.uri}}</a>
            </div>

        </v-client-table>
    </div>

</template>

<script>
  import axios from 'axios';
  let api = window.BASE_API || "/";

  axios.defaults.baseURL = window.BASE_API || "/";

  export default {
    name: 'app',
    data: function () {
      return {
        api: api,
        rows: [],
        columns: [
          'ID',
          'Antecedent',
          'Status',
          'Automated',
          'Locked',
          // 'Ignore',
          // 'SyncError',
          // 'Antecedent',
          // 'ReadOnly',
          'Containers',
          'Policies',
          'Action'

        ],
        options: {
          // childRow: 'ContainerInfo',
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
              return row.Automated.toString();
            },
            Locked (h, row) {
              return row.Locked.toString();
            },
            Policies (h, row) {
              return JSON.stringify(row.Policies);
            },

          }
        },
        // config: {
        //   checkbox_rows: true,
        //   rows_selectable: true,
        //   card_mode: false,
        //   card_title: 'Vue Bootsrap 4 advanced table'
        // }
      };
    },
    components: {
      // VueBootstrap4Table
      // eslint-disable-next-line vue/no-unused-components
      // ContainerInfo
      // Simplert
    },
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

        axios.post('/api/flux/v9/update-manifests', data)
          .then(function (response) {
            self.rows = response.data;
            // eslint-disable-next-line no-console
            console.log(response.data, self.rows);
            // self.total_rows = response.data.total;
            self.fetchData();

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
    },
    mounted () {
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