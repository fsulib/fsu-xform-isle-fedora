Patches and additional files required to break the monolith are in the transformations directory, which preserves the directory structure of isle-fedora.

The config directory contains the contents of Isle's config/fedora directory:

- fedora/akubra-llstore.xml is bind-mounted to /usr/local/fedora/server/config/spring/akubra-llstore.xml in the Fedora container.

- gsearch/RELS-EXT_to_solr.xslt is bind-mounted to /usr/local/tomcat/webapps/fedoragsearch/WEB-INF/classes/fgsconfigFinal/index/FgsIndex/islandora_transforms/RELS-EXT_to_solr.xslt in the Fedora container.

- gsearch/foxmlToSolr.xslt is bind-mounted to /usr/local/tomcat/webapps/fedoragsearch/WEB-INF/classes/fgsconfigFinal/index/FgsIndex/foxmlToSolr.xslt in the Fedora container.

akubra-llstore doc for Fedora3: https://wiki.lyrasis.org/display/FEDORA36/Configuring+Low+Level+Storage

gsearch/RELS-EXT_to_solr.xslt appears to originate from https://github.com/discoverygarden/islandora_transforms

gsearch/foxmlToSolr.xslt might come from https://github.com/discoverygarden/basic-solr-config
