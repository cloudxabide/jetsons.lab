# Infrastructure Requirements

## DNS
Not a requirement, I suppose, more of a recommendation - use DNS.

I use Red Hat Identity Management in my Lab for DNS (and other things).

```
kinit admin

ipa dnszone-add    jetsons.lab. --admin-email=root@matrix.lab --minimum=3000 --dynamic-update=true
ipa dnsrecord-add  jetsons.lab     'elroy'     --a-rec   10.10.10.51
ipa dnsrecord-add  jetsons.lab     'judy'      --a-rec   10.10.10.52
ipa dnsrecord-add  jetsons.lab     'jane'      --a-rec   10.10.10.53
ipa dnsrecord-add  jetsons.lab     'george'    --a-rec   10.10.10.54
ipa dnsrecord-add  10.10.10.in-addr.arpa       51   --ptr-rec elroy.jetsons.lab.
ipa dnsrecord-add  10.10.10.in-addr.arpa       52   --ptr-rec judy.jetsons.lab.
ipa dnsrecord-add  10.10.10.in-addr.arpa       53   --ptr-rec jane.jetsons.lab.
ipa dnsrecord-add  10.10.10.in-addr.arpa       54   --ptr-rec george.jetsons.lab.
ipa dnsrecord-add  jetsons.lab      worker-0    --cname-rec='elroy.jetsons.lab.'
ipa dnsrecord-add  jetsons.lab      worker-1    --cname-rec='judy.jetsons.lab.'
ipa dnsrecord-add  jetsons.lab      master-0    --cname-rec='jane.jetsons.lab.'
ipa dnsrecord-add  jetsons.lab      master-1    --cname-rec='george.jetsons.lab.'
ipa dnszone-mod --allow-transfer='192.168.0.0/24;10.10.10.0/24;127.0.0.1' jetsons.lab
```
