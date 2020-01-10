# Flux-ui 
This is project for providing web ui for fluxctl. 

## Install through helm (tested helm-v3)

```shell script

$ helm repo add flux-ui 'https://raw.githubusercontent.com/sureshamk/flux-ui/master/flux-ui'
$ helm repo update
$ helm search repo flux-ui
NAME           	CHART VERSION	APP VERSION	DESCRIPTION
flux-ui/flux-ui	0.1.0        	1.0        	A Helm chart for flux-ui to interact with fluxctl

$ helm install flux-web-ui flux-ui/flux-ui --set config.END_POINT="http://flux:3030/"
```
Note: `config.END_POINT="http://flux:3030/"` this end point should be valid flux service running on your cluster 


### Home 
<img src="docs/screen-shots/Home.png"/>

### View workloads 
<img src="docs/screen-shots/detail.png"/>

### deal with actions
* Lock / unlock the workload
* Automate / de-automate the workload
* Release the workload
* sync

<img src="docs/screen-shots/action.png"/>

### List images 
<img src="docs/screen-shots/list-images.png"/>

#### Built with 
* vue.js

##### TODO
* please raise a feature request :) 

## Support

* Please don't write mails directly to the maintainers.
* Use the Github issue tracker instead.