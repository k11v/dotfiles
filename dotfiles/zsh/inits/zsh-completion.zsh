# Enable arrow controls for completion and highlight selection
zstyle ":completion:*" menu select
# Colorize file completion
zstyle ":completion:*" list-colors "${(s.:.)LS_COLORS}"
# Make completion match case-insensitive for lowercase
zstyle ":completion:*" matcher-list 'm:{[:lower:]}={[:upper:]}'
# Prevent pasting with tabs from performing completion
zstyle ":completion:*" insert-tab pending
# Speed up completion for some programs by enabling cache for them
zstyle ":completion:*" use-cache on
# Specify completion cache directory for programs to use
zstyle ":completion:*" cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"
# Populate hostname completion
zstyle -e ":completion:*:hosts" hosts 'reply=(${=${=${=${${(f)"$(cat {/etc/ssh/ssh_,~/.ssh/}known_hosts(|2)(N) 2> /dev/null)"}%%[#| ]*}//\]:[0-9]*/ }//,/ }//\[/ } ${=${(f)"$(cat /etc/hosts(|)(N) <<(ypcat hosts 2> /dev/null))"}%%(\#${_etc_host_ignores:+|${(j:|:)~_etc_host_ignores}})*} ${=${${${${(@M)${(f)"$(cat ~/.ssh/config 2> /dev/null)"}:#Host *}#Host }:#*\**}:#*\?*}})'
# Don't complete uninteresting users...
zstyle ":completion:*:users" ignored-patterns adm amanda apache avahi beaglidx bin cacti canna clamav daemon dbus distcache dovecot fax ftp games gdm gkrellmd gopher hacluster haldaemon halt hsqldb ident junkbust ldap lp mail mailman mailnull mldonkey mysql nagios named netdump news nfsnobody nobody nscd ntp nut nx openvpn operator pcap postfix postgres privoxy pulse pvm quagga radvd rpc rpcuser rpm shutdown squid sshd sync uucp vcsa xfs '_*'
# ...unless we really want to
zstyle ":completion:*" single-ignored show
# Denoise ssh, scp and rsync completion
zstyle ":completion:*:(ssh|scp|rsync):*" tag-order 'hosts:-host:host hosts:-domain:domain hosts:-ipaddr:ip\ address *'
zstyle ":completion:*:(ssh|scp|rsync):*:hosts-host" ignored-patterns '*(.|:)*' loopback ip6-loopback localhost ip6-localhost broadcasthost
zstyle ":completion:*:(ssh|scp|rsync):*:hosts-domain" ignored-patterns '<->.<->.<->.<->' '^[-[:alnum:]]##(.[-[:alnum:]]##)##' '*@*'
zstyle ":completion:*:(ssh|scp|rsync):*:hosts-ipaddr" ignored-patterns '^(<->.<->.<->.<->|(|::)([[:xdigit:].]##:(#c,2))##(|%*))' '127.0.0.<->' '255.255.255.255' '::1' 'fe80::*'

# Initialize completion from cache and regenerate it once a day if needed
autoload -Uz compinit
if [ "$ZCOMPDUMP"(N.mh-24) ]; then
    # Cache is still fresh therefore don't regenerate it
    compinit -C -d "$ZCOMPDUMP"
else
    # Cache is older than 24 hours, regenerate it if needed
    compinit -d "$ZCOMPDUMP"
    # Update cache's timestamp if it didn't need regeneration
    touch "$ZCOMPDUMP"
fi;
