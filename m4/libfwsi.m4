dnl Functions for libfwsi
dnl
dnl Version: 20111009

dnl Function to detect if libfwsi is available
AC_DEFUN([AX_LIBFWSI_CHECK_LIB],
 [dnl Check if parameters were provided
 AS_IF(
  [test x"$ac_cv_with_libfwsi" != x && test "x$ac_cv_with_libfwsi" != xno && test "x$ac_cv_with_libfwsi" != xauto-detect],
  [AS_IF(
   [test -d "$ac_cv_with_libfwsi"],
   [CFLAGS="$CFLAGS -I${ac_cv_with_libfwsi}/include"
   LDFLAGS="$LDFLAGS -L${ac_cv_with_libfwsi}/lib"],
   [AC_MSG_WARN([no such directory: $ac_cv_with_libfwsi])
   ])
  ])

 AS_IF(
  [test x"$ac_cv_with_libfwsi" != xno],
  [dnl Check for headers
  AC_CHECK_HEADERS([libfwsi.h])
 
  AS_IF(
   [test "x$ac_cv_header_libfwsi_h" = xno],
   [ac_cv_libfwsi=no],
   [ac_cv_libfwsi=yes
   AC_CHECK_LIB(
    fwsi,
    libfwsi_get_version,
    [],
    [ac_cv_libfwsi=no])
  
   dnl TODO add functions
   ])
  ])

 AS_IF(
  [test "x$ac_cv_libfwsi" = xyes],
  [AC_SUBST(
   [HAVE_LIBFWSI],
   [1]) ],
  [AC_SUBST(
   [HAVE_LIBFWSI],
   [0])
  ])
 ])

dnl Function to detect how to enable libfwsi
AC_DEFUN([AX_LIBFWSI_CHECK_ENABLE],
 [AX_COMMON_ARG_WITH(
  [libfwsi],
  [libfwsi],
  [search for libfwsi in includedir and libdir or in the specified DIR, or no if to use local version],
  [auto-detect],
  [DIR])

 AX_LIBFWSI_CHECK_LIB

 AS_IF(
  [test "x$ac_cv_libfwsi" != xyes],
  [AC_DEFINE(
   [HAVE_LOCAL_LIBFWSI],
   [1],
   [Define to 1 if the local version of libfwsi is used.])
  AC_SUBST(
   [HAVE_LOCAL_LIBFWSI],
   [1])
  AC_SUBST(
   [LIBFWSI_CPPFLAGS],
   [-I../libfwsi])
  AC_SUBST(
   [LIBFWSI_LIBADD],
   [../libfwsi/libfwsi.la])

  ac_cv_libfwsi=local
  ])

 AM_CONDITIONAL(
  [HAVE_LOCAL_LIBFWSI],
  [test "x$ac_cv_libfwsi" = xlocal])

 AS_IF(
  [test "x$ac_cv_libfwsi" = xyes],
  [AC_SUBST(
   [ax_libfwsi_pc_libs_private],
   [-lfwsi])
  ])

 AS_IF(
  [test "x$ac_cv_libfwsi" = xyes],
  [AC_SUBST(
   [ax_libfwsi_spec_requires],
   [libfwsi])
  AC_SUBST(
   [ax_libfwsi_spec_build_requires],
   [libfwsi-devel])
  ])
 ])
