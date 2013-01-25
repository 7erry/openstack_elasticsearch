

			Copyright 2013 Terry Walters

   ------------------------------------------------------------------------
   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.

   ------------------------------------------------------------------------

	Theses scripts:
		* downloads and installs openjdk7
		* downloads and installs Elastic Search
		* Installs the cloud plugin
		* Configures the cloud plugin
		* Employs both Region and Security Groups for auto discovery
		* use euca2ools to instantiate the entire cluster


	1) Modify es_node.sh with EC2 credentials and Security Group  
	2) Create a cluster:
		launchES.sh -i ami-00000021 -g ElasticSearch -k mypem -t m2.xlarge -n 100

	You have a 100 node cluster of elastic search.

	node_instances.txt contains the instance id and description for the nodes.

