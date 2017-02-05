$(patsubst %,binary-install/%,$(DEB_PACKAGES)) :: binary-install/%:
	$(if $(DEB_MK_COMPAT_DESKTOP_$(cdbs_curpkg)), /usr/bin/pkg-gnome-compat-desktop-file $(DEB_MK_COMPAT_DESKTOP_$(cdbs_curpkg)))
