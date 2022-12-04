# NAME

inet - IP Address Tools for Tcl

# SYNOPSIS

**package require inet** ?0.1?

**inet type** *addr*

# DESCRIPTION

This package provides efficient manipulation of IP address (IPv4 and
IPv6) for Tcl. Future versions are planned to include features like
testing whether an address is contained in a specified network range,
extract the network portion from a CIDR address, compare addresses for
sorting, etc.

The core address parsing is implemented with a re2c parser using the
jitc extension for very fast parsing.

# COMMANDS

  - **inet type** *addr*  
    Returns the type of address of *addr*, or “invalid” if *addr* is not
    a valid address.
    
    | Type      | Description                                  | Example                             |
    | --------- | -------------------------------------------- | ----------------------------------- |
    | ipv4      | An IPv4 address                              | 127.0.0.1                           |
    | ipv4\_net | An IPv4 address with a network prefix length | 10.1.0.0/16, 127.0.0.1/32 0.0.0.0/0 |
    | ipv6      | An IPv6 address                              | ::1, ::ffff:127.0.0.1, 2001:db8::2  |
    | ipv6\_net | An IPv6 address with a prefix length         | 2001:db8::/32                       |
    | invalid   | *addr* is not a valid IP address             | foo, 10.1.1.1.2                     |
    

# EXAMPLES

Test if the received value is a valid IP address and not a network:

``` tcl
if {[inet type $addr] in {ipv4 ipv6}} {
    puts "valid"
}
```

Test if the received value is any sort of valid address:

``` tcl
if {[inet type $addr] eq "invalid"} {
    puts stderr "Address \"$addr\" is not valid"
}
```

# DEPENDENCIES

This package requires the just-in-time c compiler for Tcl jitc:
https://github.com/cyanogilvie/jitc

# BUGS

Please report any bugs to the github issue tracker:
https://github.com/cyanogilvie/inet/issues

# LICENSE

This package is placed in the public domain. If you live in a place that
does not recognise the public domain you may do anything you want with
this software under the 0BSD license.
