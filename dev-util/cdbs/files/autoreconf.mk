# autoreconf.mk - dh-autoreconf integration for CDBS.

CDBS_BUILD_DEPENDS_rules_autoreconf := dh-autoreconf
CDBS_BUILD_DEPENDS += , $(CDBS_BUILD_DEPENDS_rules_autoreconf)

post-patches:: debian/autoreconf.after

debian/autoreconf.after:
	dh_autoreconf $(DEB_DH_AUTORECONF_ARGS)

reverse-config::
	dh_autoreconf_clean $(DEB_DH_AUTORECONF_CLEAN_ARGS)
