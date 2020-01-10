# Flux-ui 
This is project for providing web ui for fluxctl. 

## Install through helm (tested helm-v3)

```console

$ helm repo add flux-ui 'https://raw.githubusercontent.com/sureshamk/flux-ui/master/flux-ui'
$ helm repo update
$ helm search repo flux-ui
NAME           	CHART VERSION	APP VERSION	DESCRIPTION
flux-ui/flux-ui	0.1.0        	1.0        	A Helm chart for flux-ui to interact with fluxctl

```


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

## Support

* Please don't write mails directly to the maintainers.
* Use the Github issue tracker instead.