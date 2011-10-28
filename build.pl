#!/usr/bin/perl -wp

s/.*\s-o\s(\S+).*/[32m$1/;
s/^ar\s.*\s(\S+\.a)\s.*/[32m$1/;
s/^lrelease\s-qm\s(\S+).*/[32m$1/;

s/$/[m/;

s/^/[31m/ if /\berror:/i;
s/^/[33m/ if /\bwarning:/i;
s/^/[34m/ if /\bnote:/i;

s/${ENV{PWD}}\/src\//~\//g;

s/^make\[1\]:.*\s//;


## boost::gil::layout
s/boost::gil::layout<boost::mpl::vector3<boost::gil::red_t, boost::gil::green_t, boost::gil::blue_t>(, boost::mpl::range_c<int, 0, 3>)? >/rgb/g;
s/boost::gil::layout<boost::mpl::vector1<boost::gil::gray_color_t>(, boost::mpl::range_c<int, 0, 1>)? >/gray/g;
s/boost::gil::layout<boost::mpl::vector3<boost::gil::hsv_color_space::hue_t, boost::gil::hsv_color_space::saturation_t, boost::gil::hsv_color_space::value_t>(, boost::mpl::range_c<int, 0, 3>)? >/hsv/g;


## boost::gil::bits
s/boost::gil::scoped_channel_value<float, boost::gil::float_zero, boost::gil::float_one>/boost::gil::bits32f/g;
s/boost::gil::scoped_channel_value<double, boost::gil::int_zero, boost::gil::int_one>/boost::gil::bits64f/g;
s/boost::gil::scoped_channel_value<char, boost::gil::int_zero, boost::gil::int_one>/boost::gil::bits8b/g;


## boost::gil::pixel
s/boost::gil::(\w*)_pixel_t/p$1/g;
s/boost::gil::pixel<unsigned char, (\w*) *>/p${1}8/g;
s/boost::gil::pixel<int, (\w*) *>/p${1}32s/g;
s/boost::gil::pixel<boost::gil::bits(\w*), (\w*) *>/p$2$1/g;


## boost::gil::image
s/boost::gil::image<p(\w*) *, false, std::allocator<unsigned char> >/i$1/g;


## boost::gil::image_view
s/boost::gil::image_view<boost::gil::memory_based_2d_locator<boost::gil::memory_based_step_iterator<p(\w*) *\*> > >/v$1/g;


## std::string
s/std::basic_string<char(, std::char_traits<char>(, std::allocator<char>)?)? *>/std::string/g;


