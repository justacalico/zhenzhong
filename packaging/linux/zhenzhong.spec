Name:           zhenzhong
Version:        @VERSION@
Release:        1%{?dist}
Summary:        Mahjongg solitaire game
License:        GPL-3.0-or-later

%global debug_package %{nil}

%description
Zhenzhong is a free and open source Mahjongg solitaire game.

%install
mkdir -p %{buildroot}/opt/zhenzhong %{buildroot}/usr/bin
cp -a %{_sourcedir}/bundle/. %{buildroot}/opt/zhenzhong/
ln -sf /opt/zhenzhong/zhenzhong %{buildroot}/usr/bin/zhenzhong
install -Dm644 %{_sourcedir}/zhenzhong.desktop %{buildroot}/usr/share/applications/gitlab.httpanimations.zhenzhong.desktop
install -Dm644 %{_sourcedir}/gitlab.httpanimations.zhenzhong.png %{buildroot}/usr/share/icons/hicolor/512x512/apps/gitlab.httpanimations.zhenzhong.png

%files
/opt/zhenzhong
/usr/bin/zhenzhong
/usr/share/applications/gitlab.httpanimations.zhenzhong.desktop
/usr/share/icons/hicolor/512x512/apps/gitlab.httpanimations.zhenzhong.png

%changelog
* Tue Nov 03 2026 Zhenzhong CI <ci@gitlab.com> - 1
- Initial RPM packaging
