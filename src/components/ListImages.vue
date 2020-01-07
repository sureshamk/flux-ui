<template>
    <div style="height: 800px;overflow: auto;">
        <ul>
            <li v-bind:key="index" v-for="(image,index) in this.images">
                <strong>Name: </strong> {{image.Name}}
                   <br>
                <strong>Current: </strong> {{image.Current.ID}}
                <!--               CreatedAt:  {{image.CreatedAt}}-->
                <!--               LastFetched:  {{image.LastFetched}}-->
                <br>
               <strong>Available Images</strong>
                <ul>
                    <li v-bind:key="index" v-for="(image,index) in image.Available">
                        {{image.ID}}
                        <br>
                        CreatedAt : {{image.CreatedAt}}
                        <hr>
                    </li>
                </ul>
                <!--               Available:  {{image.Available}}-->
                <hr>
                <!--                <pre>{{image}}</pre>-->
            </li>
        </ul>
    </div>
</template>

<script>
  export default {
    name: 'ListImages',
    props: {
      images: Array
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