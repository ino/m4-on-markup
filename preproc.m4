dnl /home/www/gmxhome/preproc.m4 _date: 20100825-2138_
dnl vim: set filetype=m4 ts=4:
dnl -*- mode: m4; -*-
dnl $HG_Id: preproc.m4 r:75 2010-08-25 b-abstract-tool ino-news $
divert(-1)dnl
changequote(`{', `}')
changecom({###},)
undefine({changequote})
undefine({changecom})
###
### rename some builtins so they don't collide with any text
###
define({__defn}, defn({defn}))
undefine({defn})
define({__ign}, __defn({dnl}))
undefine({dnl})
define({__def}, __defn({define}))
undefine({define})
__def({__undivert}, __defn({undivert}))
undefine({undivert})
__def({__divert}, __defn({divert}))
undefine({divert})
__def({__switch}, __defn({ifelse}))
undefine({ifelse})
__def({__eval}, __defn({eval}))
undefine({eval})
__def({__len}, __defn({len}))
undefine({len})
__def({__errprint}, __defn({errprint}))
undefine({errprint})
__def({__exit}, __defn({m4exit}))
undefine({m4exit})
__def({__include}, __defn({include}))
undefine({include})
__def({__sed}, __defn({patsubst}))
undefine({patsubst})
### __warning({text})
__def({__warning}, __ign
{__errprint(__program__:__file__:__line__{: warning: "$*"
})})
### __error({text})
__def({__error}, __ign
{__errprint(__program__:__file__:__line__{: error: "$*"
})__exit({9})})
### __sys({command}) should run in a diversion (9, reserved!)
### doesn't work right w/ esyscmd(), because it expands cmd-output!
### __def({___sys}, __defn({esyscmd}))
__def({__sysval}, __defn({sysval}))
### __def({__sys}, __defn({esyscmd}))
__def({___sys}, __defn({syscmd}))
undefine({syscmd}, {sysval})
__def({__sys}, __ign
{__divert({9})__ign
___sys({$1})
__undivert({9})__ign
__switch(__sysval, {0}, {}, {__error(__sysval{}{: $1})})})
### undefine undefine to disable accidental undefine
undefine({undefine})
###
### __def({_utter_truth_}, {__eval(5>0)})
### __def({_param_given_}, {__eval(__len({$1}) > 0)})
### __switch(__eval(__len({$1}) > 0), {1}, __def({_fg_}, {$1}))
### __switch({_param_given_({$1})}, {_utter_truth_}, {__def({_fg_}, {$1})})
### if arg1 is given, define arg2 to be arg1, else define arg2 to be arg3
__def({_def_w_default}, __ign
{__switch({$1}, {}, {__def({$2},{$3})}, {__def({$2},{$1})})})__ign
###
### set defaults possibly given in Makefile:
### std_fg, std_bg, std_standout_fg, std_sz, std_email, std_email_txt
###
_def_w_default(__defn({builder}), {_builder_}, {asciidoc})
_def_w_default(__defn({std_fg}), {_std_fg_}, {white})
_def_w_default(__defn({std_bg}), {_std_bg_}, {blue})
_def_w_default(__defn({std_standout_fg}), {_std_standout_fg_}, {red})
_def_w_default(__defn({std_sz}), {_std_sz_}, {+1.5})
_def_w_default(__defn({alt_download_loc}), {_alt_download_loc_}, {http://spotteswoode.dnsalias.org:8080/})
_def_w_default(__defn({std_email}), {_std_email_}, {<ino-news@spotteswoode.dnsalias.org>})
_def_w_default(__defn({std_email_txt}), {_std_email_txt_},
{clemens fischer, ino-news AT spotteswoode DOT dnsalias DOT org})
###
### output alternate download location prefixed by {_alt_download_loc_}
###
__def({_alt_download_}, _alt_download_loc_{}{$1})__ign
###
### abstract the tool (docutils/reST, asciidoc) away
###
__def({_tool_choice_}, {'build' tool must be one of 'asciidoc', 'docutils', 'txt2tags'})
###
### The following definitions depend on the build tool used.
###
###
### "asciidoc" stuff
###
__switch(_builder_, {asciidoc}, { __ign
###
### _standout_({some text})
###
__def({_standout_fg_bg_sz_}, {__ign
_def_w_default($1, {_fg_}, {})__ign
_def_w_default($2, {_bg_}, {})__ign
_def_w_default($3, {_sz_}, {})__ign
{[}_fg_{,}_bg_{,}_sz_{]}})
__def({_standout_fg_bg_}, {_standout_fg_bg_sz_({$1}, {$2},)})
__def({_standout_fg_}, {_standout_fg_bg_sz_({$1},,)})
__def({_standout_sz_}, {_standout_fg_bg_sz_(,, {$1})})
__def({_standout_},
{_standout_fg_bg_sz_({_std_standout_fg_},,{_std_sz_}){_}{$1}{_}})
###
### _doc_header_({title}, {author})
###
__def({_doc_header_}, {__ign
$1
{==================================================================}
{:Author:} $2
{:Date:} __sys({date '+%Y-%m-%d %H:%M'})
})
###
### _comment_({anything})
###
__def({_comment_}, {})
###
### _sidebar_({sidebar text})
###
__def({_sidebar_}, {__ign
{*************************}
$1
{*************************}
})
###
### _note_({text})
###
__def({_note_}, {__ign
{[NOTE]}
$1})
###
### _tip_({text})
###
__def({_tip_}, {__ign
{[TIP]}
$1})
###
### _header_2_({text})
###
__def({_header_2_}, {__ign
{== }$1
})
###
### _header_3_({text})
###
__def({_header_3_}, {__ign
{=== }$1
})
###
### _llink_({link_target}, {caption})
###
__def({_llink_}, {__ign
{link:}$1{[}$2{]}})
###
### _include_({file})
###
__def({_include_}, {__ign
__include({$1})})
###
### _para_title_({title})
###
__def({_para_title_}, {__ign
.{}$1})
###
### _anchor_({anchor})
###
__def({_anchor_}, {__ign
{[[}$1{]]}})
###
### "anchor reference"
### _anchor_r_({anchor}, {tag})
###
__def({_anchor_r_}, {__ign
{<<}$1{,}$2{>>}})
###
### _ul_e_({unnumbered list item})
###
__def({_ul_e_}, {__ign
{-} $1})
###
}, __ign
###
### "docutils" stuff
###
_builder_, {docutils}, { __ign
__error({using "docutils" isn't implemented yet})
}, __ign
###
### "txt2tags" stuff
###
_builder_, {txt2tags}, { __ign
__error({using "txt2tags" isn't implemented yet})
###
### wrong (unimplemented) build tool
###
}, { __ign
__error(_tool_choice_)
})
###
### traceon (use "m4 -daeqt ...")
### traceon({_def_w_default})
__divert{}__ign
