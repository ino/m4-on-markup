dnl /home/www/gmxhome/preproc.m4 _date: 20100902-2130_
dnl vim: set filetype=m4 ts=4:
dnl -*- mode: m4; -*-
dnl $HG_Id: preproc.m4 r:79 2010-08-27 b-abstract-tool ino-news $
divert(-1)dnl
changequote(`{', `}')
changecom({###},)
undefine({changequote})
undefine({changecom})
###
### rename some builtins so they don't collide with any text
###
### or maybe pushdef()?
define({__rename}, {define({$2}, defn({$1}))undefine({$1})})
###
define({__defn}, defn({defn}))
undefine({defn})
define({__def}, __defn({define}))
undefine({define})
### undefine undefine to disable accidental undefine
__def({__undefine}, __defn({undefine}))
undefine({undefine})
__def({__ign}, __defn({dnl}))
__undefine({dnl})
__def({__switch}, __defn({ifelse}))
__undefine({ifelse})
__def({__eval}, __defn({eval}))
__undefine({eval})
__def({__len}, __defn({len}))
__undefine({len})
__def({__pushdef}, __defn({pushdef}))
__undefine({pushdef})
__def({__popdef}, __defn({popdef}))
__undefine({popdef})
__def({__incr}, __defn({incr}))
__undefine({incr})
__def({__errprint}, __defn({errprint}))
__undefine({errprint})
__def({__exit}, __defn({m4exit}))
__undefine({m4exit})
__def({__shift}, __defn({shift}))
__undefine({shift})
__def({__include}, __defn({include}))
__undefine({include})
__def({__ifdef}, __defn({ifdef}))
__undefine({ifdef})
__def({__sed}, __defn({patsubst}))
__undefine({patsubst})
### __warning({text})
__def({__warning},
{__errprint(__program__:__file__:__line__{: warning: "$*"
})})
### __error({text})
__def({__error},
{__errprint(__program__:__file__:__line__{: error: "$*"
})__exit({9})})
### __first(arglist), __rest(arglist)
__def({__first}, {$1})
__def({__rest}, {__shift($@)})
### wrap divert() and undivert() so that all current diversions are
### known.
__def({__undivert}, __defn({undivert}))
__undefine({undivert})
### __def({___divert}, __defn({divert}))
__def({__divert}, __defn({divert}))
__undefine({divert})
### ########################################
### from m4-1.4.14/examples/stack.m4
### __stack_foreach(macro, action)
### Invoke ACTION with a single argument of each definition
### from the definition stack of MACRO, starting with the oldest.
__def({__stack_foreach},
{__stack_reverse({$1}, {tmp-$1})}__ign
{__stack_reverse({tmp-$1}, {$1}, {$2(__defn({$1}))})})
### __stack_foreach_lifo(macro, action)
### Invoke ACTION with a single argument of each definition
### from the definition stack of MACRO, starting with the newest.
__def({__stack_foreach_lifo},
{__stack_reverse({$1}, {tmp-$1}, {$2(__defn({$1}))})}__ign
{__stack_reverse({tmp-$1}, {$1})})
__def({__stack_reverse},
{__ifdef({$1}, {__pushdef({$2}, __defn({$1}))$3{}__popdef({$1})$0($@)})})
### ########################################
### from m4-1.4.14/examples/join.m4
### __join(sep, args) - join each non-empty ARG into a single
### string, with each element separated by SEP
__def({__join},
{__switch({$#}, {2}, {{$2}},
  {__switch({$2}, {}, {}, {{$2}_})$0({$1}, __shift(__shift($@)))})})
__def({___join},
{__switch({$#$2}, {2}, {},
  {__switch({$2}, {}, {}, {{$1$2}})$0({$1}, __shift(__shift($@)))})})
### __joinall(sep, args) - join each ARG, including empty ones,
### into a single string, with each element separated by SEP
__def({__joinall}, {{$2}_$0({$1}, __shift($@))})
__def({___joinall},
{__switch({$#}, {2}, {}, {{$1$3}$0({$1}, __shift(__shift($@)))})})
### ########################################
### __sys({command}) should run in a diversion (9, reserved!)
### doesn't work right w/ esyscmd(), because it expands cmd-output!
### __def({___sys}, __defn({esyscmd}))
### __def({__sys}, __defn({esyscmd}))
__def({__sysval}, __defn({sysval}))
__def({___sys}, __defn({syscmd}))
__undefine({syscmd}, {sysval})
### __undivert_all{}__ign
__def({__sys}, {__ign
__undivert({0})__ign
__divert({9})__ign
___sys({$1})
__undivert({9})__ign
__divert({0})__ign
__switch(__sysval, {0}, {}, {__error(__sysval{}{: $1})})})
###
### repeat (the text of) {something} {howmany} times
### __repl_c_({character-or-something}, {howmany})
###
__def({___repl_c_},
{__switch({$3}, {$2}, {}, {$1{}$0($1, $2, __incr($3))})})
###
__def({__repl_c_}, {___repl_c_($1, $2, {0})})
###
### __def({_utter_truth_}, {__eval(5>0)})
### __def({_param_given_}, {__eval(__len({$1}) > 0)})
### __switch(__eval(__len({$1}) > 0), {1}, __def({_fg_}, {$1}))
### __switch({_param_given_({$1})}, {_utter_truth_}, {__def({_fg_}, {$1})})
### if arg1 is given, define arg2 to be arg1, else define arg2 to be arg3
__def({_def_w_default},
{__switch({$1}, {}, {__def({$2},{$3})}, {__def({$2},{$1})})})
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
__def({_alt_download_}, _alt_download_loc_{}{$1})
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
__switch(_builder_, {asciidoc}, {__ign
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
__def({_doc_header_},
{$1
__repl_c_({=}, __len({$1}))
{:Author:} $2
{:Date:} __sys({date '+%Y-%m-%d %H:%M'})
})
###
### _h_ruler_
### a horizontal ruler across the page
###
__def({_h_ruler_},
{
''''
})
###
### _pass_through_({anything})
###
__def({_pass_through_},
{
++++
$1
++++
})
###
### _comment_({anything})
###
__def({_comment_}, {})
###
### _sidebar_({sidebar text})
###
__def({_sidebar_},
{__pushdef({__ruler__text__}, $1)__ign
__pushdef({__ruler__sidebar__}, {__repl_c_({*}, __len(__ruler__text__))})__ign
__ruler__sidebar__
__ruler__text__
__ruler__sidebar__
__popdef({__ruler__text__}, {__ruler__sidebar__})__ign
})
###
### _note_({text})
###
__def({_note_},
{{[NOTE]}
$1
})
###
### _warning_({text})
###
__def({_warning_},
{{[WARNING]}
$1
})
###
### _tip_({text})
###
__def({_tip_},
{{[TIP]}
$1
})
###
### _code_({text})
###
__def({_code_},
{
{----}
$1
{----}
})
###
### _cmd_({some command})
###
__def({_cmd_}, {{`}$1{`}})
###
### _prog_out_({command}, {optional paragraph title})
###
__def({_prog_out_},
{__switch({$2}, {},
{_para_title_({Output of: }{_cmd_({$1})})},
{_para_title_({$2})})
{----}
__sys({$1})
{----}
})
###
### _literal_({text})
### literal text must be indented
###
__def({_literal_}, {__sed({$1}, {^}, {  })})
###
### _italic_({text})
###
__def({_italic_}, {{_}$1{_}})
###
### _bold_({text})
###
__def({_bold_}, {{*}$1{*}})
###
### _mono_({text})
###
__def({_mono_}, {{+}$1{+}})
###
### _dquote_({text})
###
__def({_dquote_}, {{``}$1{''}})
###
### _squote_({text})
###
__def({_squote_}, {{`}$1{'}})
###
### _super_s_({text})
###
__def({_super_s_}, {{^}$1{^}})
###
### _sub_s_({text})
###
__def({_sub_s_}, {{~}$1{~}})
###
### _header_2_({text})
###
__def({_header_2_},
{{== }$1
})
###
### _header_3_({text})
###
__def({_header_3_},
{{=== }$1
})
###
### _link_({link_target}, {caption})
### external link
###
__def({_link_},
{$1{[}__switch({$2}, {}, {$1}, {$2}){]}})
###
### _llink_({link_target}, {caption})
### local link
###
__def({_llink_}, {{link:}$1{[}$2{]}})
###
### _include_({file})
###
__def({_include_}, {__include({$1})})
###
### _definition_({term}, {definition})
###
__def({_definition_},
{$1{::}
__sed({$2}, {^}, {  })})
###
### _para_title_({title})
###
__def({_para_title_}, {.{}$1})
###
### _anchor_({anchor})
###
__def({_anchor_}, {{[[}$1{]]}})
###
### "anchor reference"
### _anchor_r_({anchor}, {tag})
###
__def({_anchor_r_}, {{<<}$1{,}$2{>>}})
###
### _nl_e_({numbered list item})
###
__def({_nl_e_}, {{.} $1})
###
### _ul_e_({unnumbered list item})
###
__def({_ul_e_}, {{-} $1})
###
},
###
### "docutils" stuff
###
_builder_, {docutils},
{__error({using "docutils" isn't implemented yet})
},
###
### "txt2tags" stuff
###
_builder_, {txt2tags},
{__error({using "txt2tags" isn't implemented yet})
###
### wrong (unimplemented) build tool
###
},
{__error(_tool_choice_)
})
###
### traceon (use "m4 -daeqt ...")
### traceon({_def_w_default})
__divert({0})__ign
