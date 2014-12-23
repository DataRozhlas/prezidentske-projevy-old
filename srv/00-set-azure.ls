require! {
  azure
}
blb = azure.createBlobService do
  "samizdat"
  "..."
(err, data) <~ blb.getServiceProperties
console.log err, data
data.DefaultServiceVersion = "2014-02-14"
(err, res) <~ blb.setServiceProperties data
console.log err, res
