Name:           pbzip2
Version:        1.1.6
Release:        0
Summary:        Parallel implementation of bzip2
URL:            http://www.compression.ca/pbzip2/
License:        BSD
Group:          Applications/Other
Source0:        %{name}-%{version}.tar.gz
BuildRequires:  bzip2-devel
BuildRequires:  gcc-c++

%description
PBZIP2 is a parallel implementation of the bzip2 block-sorting file
compressor that uses pthreads and achieves near-linear speedup on SMP
machines.  The output of this version is fully compatible with bzip2
v1.0.2 or newer (ie: anything compressed with pbzip2 can be
decompressed with bzip2).

%prep
%setup -q

%build
make %{?_smp_mflags}

%install
install -Dm755 pbzip2 %{buildroot}%{_bindir}/pbzip2
install -Dm644 pbzip2.1 %{buildroot}%{_mandir}/man1/pbzip2.1
ln -s pbzip2 %{buildroot}%{_bindir}/pbunzip2
ln -s pbzip2 %{buildroot}%{_bindir}/pbzcat

%docs_package

%files
%license COPYING
%{_bindir}/pbzip2
%{_bindir}/pbunzip2
%{_bindir}/pbzcat
