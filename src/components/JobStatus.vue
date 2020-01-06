<template>
    <span>
            <i v-if="status=='running'" class="fa fa-refresh fa-spin"
               style="font-size:15px"></i>
    <i v-if="status=='done'" class="fa fa-check"
       style="font-size:15px;color: green"></i>
    <i v-if="status=='skipped'" class="fa fa-exclamation-circle"
       style="font-size:15px;color: #e39200"></i>
    </span>
</template>

<script>
  export default {
    name: 'JobStatus',
    props: {
      status: String
    },
    data () {
      return {
        // 'status': 'running'
      };
    }
  };
</script>

<style scoped>

</style>