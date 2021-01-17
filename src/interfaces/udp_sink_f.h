/* -*- c++ -*- */
/*
 * Gqrx SDR: Software defined radio receiver powered by GNU Radio and Qt
 *           https://gqrx.dk/
 *
 * Copyright 2013 Alexandru Csete OZ9AEC.
 *
 * Gqrx is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3, or (at your option)
 * any later version.
 *
 * Gqrx is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Gqrx; see the file COPYING.  If not, write to
 * the Free Software Foundation, Inc., 51 Franklin Street,
 * Boston, MA 02110-1301, USA.
 */
#ifndef UDP_SINK_F_H
#define UDP_SINK_F_H

#include <gnuradio/hier_block2.h>
#include <gnuradio/blocks/float_to_short.h>
#include <gnuradio/blocks/udp_sink.h>
#include <gnuradio/blocks/interleave.h>
#include <gnuradio/blocks/null_sink.h>


class udp_sink_f;

#if GNURADIO_VERSION < 0x030900
typedef boost::shared_ptr<udp_sink_f> udp_sink_f_sptr;
#else
typedef std::shared_ptr<udp_sink_f> udp_sink_f_sptr;
#endif

udp_sink_f_sptr make_udp_sink_f(void);

class udp_sink_f : public gr::hier_block2
{
public:
    udp_sink_f(void);
    ~udp_sink_f();

    void start_streaming(const std::string host, int port, bool stereo);
    void stop_streaming(void);

private:
    gr::blocks::udp_sink::sptr        d_sink;   /*!< The gnuradio UDP sink. */
    gr::blocks::float_to_short::sptr  d_f2s;    /*!< Converts float to short. */
    gr::blocks::interleave::sptr      d_inter;  /*!< Stereo interleaver. */
    gr::blocks::null_sink::sptr       d_null0;  /*!< Null sink for mono. */
    gr::blocks::null_sink::sptr       d_null1;  /*!< Null sink for mono. */

};


#endif // UDP_SINK_F_H
