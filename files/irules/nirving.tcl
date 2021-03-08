when HTTP_REQUEST {
    log local0. "Adding header"
    HTTP::header insert Example-Header true
}

when CLIENTSSL_CLIENTCERT {
    if {[SSL::cert 0] ne ""} {
        set subject_dn [X509::subject [SSL::cert 0]]
        log user. "Client Certificate Received: $subject_dn"
        if { ([matchclass $subject_dn contains my_cn_list])} {
            log local0. "Client Certificate Accepted: $subject_dn"
        } else {
            log local0. "No Matching Client Certificate found using $subject_dn"
            reject
        }
    } else {
        log user. "why here"
    }
}

when CLIENT_ACCEPTED priority 250 {
    log local0. "CLIENT_ACCEPTED"
    TCP::collect
}

when CLIENT_DATA priority 250 {
    set sni [call nirving-library-rule::getSNI [TCP::payload]]
    log local0. "CLIENT_DATA: ${sni}"
    TCP::release
}