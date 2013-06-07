#Leadfiles application

With this application you can link important documents stored on Sharefile, to the company's Leads from Salesforce.
This application uses a combination of KidoZen for Integrating Different Services with a single SDK, and Citrix MDX for Mobile Device Management.

Also is a simple example that shows how to use the KidoZen SDK for iOS with the following services:

- `Storage`
- `Services`

##How to use it

<div class="row">
	<div class="span3">
		<div class="well">
			Once deployed in the device launch the application and configure it to use your kidozen credentials by pressing the Action Button on the device. Here you must provide the following values:
		</div>
	</div>
	<div class="span4">
		<div class="well">
			<li>Tenant: The url of the KidoZen marketplace</li>
			<li>Application: The application name</li>
			<li>User: The user account</li>
			<li>Password: The password for the user</li>
			<li>ShareFile user: Sharefile user name</li>
			<li>ShareFile Password: Sharefile password</li>
		</div>
	</div>
</div>

##User interface

The application shows a single screen to display sharefile's folder. If the item is a folder you can browse it, if the item is a file you can get the file information.
You can also assing a ShareFile file to a Lead, to do that, do a "logn press" on the file and a contextual menu will appears. 

##Code structure

The application has a singleton class KidoZen that implements an simple model that interacts with the KidoZen API. This class is used as a model, and it encapsulates all the calls to the KidoZen SDK 




