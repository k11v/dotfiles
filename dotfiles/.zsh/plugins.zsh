
# define plugins to apply
bundles="\
mafredri/zsh-async
zsh-users/zsh-completions
sindresorhus/pure
zsh-users/zsh-syntax-highlighting
"

# initialize antibody
source <(antibody init)
# apply plugins
antibody bundle $bundles

# clean up
unset bundles
