// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2017 (c) Analog Devices, Inc. All rights reserved.
//
// In this HDL repository, there are many different and unique modules, consisting
// of various HDL (Verilog or VHDL) components. The individual modules are
// developed independently, and may be accompanied by separate and unique license
// terms.
//
// The user should read each of these license terms, and understand the
// freedoms and responsibilities that he or she has by using this source/core.
//
// This core is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
// A PARTICULAR PURPOSE.
//
// Redistribution and use of source or resulting binaries, with or without modification
// of this file, are permitted under one of the following two license terms:
//
//   1. The GNU General Public License version 2 as published by the
//      Free Software Foundation, which can be found in the top level directory
//      of this repository (LICENSE_GPL2), and also online at:
//      <https://www.gnu.org/licenses/old-licenses/gpl-2.0.html>
//
// OR
//
//   2. An ADI specific BSD license, which can be found in the top level directory
//      of this repository (LICENSE_ADIBSD), and also on-line at:
//      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module axi_simplereg #(
  parameter   integer ID = 0)

 (

  // axi interface

  input             s_axi_aclk,
  input             s_axi_aresetn,
  input             s_axi_awvalid,
  input   [ 15:0]   s_axi_awaddr,
  output            s_axi_awready,
  input             s_axi_wvalid,
  input   [ 31:0]   s_axi_wdata,
  input   [  3:0]   s_axi_wstrb,
  output            s_axi_wready,
  output            s_axi_bvalid,
  output  [  1:0]   s_axi_bresp,
  input             s_axi_bready,
  input             s_axi_arvalid,
  input   [ 15:0]   s_axi_araddr,
  output            s_axi_arready,
  output            s_axi_rvalid,
  output  [ 31:0]   s_axi_rdata,
  output  [  1:0]   s_axi_rresp,
  input             s_axi_rready,
  input   [ 2:0]    s_axi_awprot,
  input   [ 2:0]    s_axi_arprot);


  // version

  localparam  [31:0]  PCORE_VERSION = 32'h00040063;

  // internal registers

  reg               up_wack_d = 'd0;
  reg               up_rack_d = 'd0;
  reg     [ 31:0]   up_rdata_d = 'd0;
  reg               up_wack = 'd0;
  reg     [ 31:0]   up_scratch = 'd0;
  reg               up_rack = 'd0;
  reg     [ 31:0]   up_rdata = 'd0;

  // internal signals

  wire              up_rstn;
  wire              up_clk;
  wire              up_wreq;
  wire    [ 13:0]   up_waddr;
  wire    [ 31:0]   up_wdata;
  wire              up_rreq;
  wire    [ 13:0]   up_raddr;
  wire              up_wreq_s;
  wire              up_rreq_s;
  wire    [ 16:0]   up_wack_s;
  wire    [ 16:0]   up_rack_s;
  wire    [ 31:0]   up_rdata_s[16:0];

  // signal name changes

  assign up_rstn = s_axi_aresetn;
  assign up_clk = s_axi_aclk;

  // up signals

  always @(posedge up_clk or negedge up_rstn) begin
    if (up_rstn == 1'b0) begin
      up_wack_d <= 1'd0;
      up_rack_d <= 1'd0;
      up_rdata_d <= 32'd0;
    end else begin
      up_wack_d <= | up_wack_s;
      up_rack_d <= | up_rack_s;
      up_rdata_d <= up_rdata_s[ 0] | up_rdata_s[ 1] | up_rdata_s[ 2] |
        up_rdata_s[ 3] | up_rdata_s[ 4] | up_rdata_s[ 5] | up_rdata_s[ 6] |
        up_rdata_s[ 7] | up_rdata_s[ 8] | up_rdata_s[ 9] | up_rdata_s[10] |
        up_rdata_s[11] | up_rdata_s[12] | up_rdata_s[13] | up_rdata_s[14] |
        up_rdata_s[15] | up_rdata_s[16];
    end
  end

  // generic register map

  assign up_wack_s[16] = up_wack;
  assign up_rack_s[16] = up_rack;
  assign up_rdata_s[16] = up_rdata;

  // decode block select

  assign up_wreq_s = (up_waddr[13:8] == 6'h00) ? up_wreq : 1'b0;
  assign up_rreq_s = (up_raddr[13:8] == 6'h00) ? up_rreq : 1'b0;

  // processor write interface

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_wack <= 'd0;
      up_scratch <= 'd0;
    end else begin
      up_wack <= up_wreq_s;
      if ((up_wreq_s == 1'b1) && (up_waddr[7:0] == 8'h02)) begin
        up_scratch <= up_wdata;
      end
    end
  end

  // processor read interface

  always @(negedge up_rstn or posedge up_clk) begin
    if (up_rstn == 0) begin
      up_rack <= 'd0;
      up_rdata <= 'd0;
    end else begin
      up_rack <= up_rreq_s;
      if (up_rreq_s == 1'b1) begin
        case (up_raddr[7:0])
          8'h00: up_rdata <= PCORE_VERSION;
          8'h01: up_rdata <= ID;
          8'h02: up_rdata <= up_scratch;
          default: up_rdata <= 0;
        endcase
      end else begin
        up_rdata <= 32'd0;
      end
    end
  end

  up_axi i_up_axi (
    .up_rstn (up_rstn),
    .up_clk (up_clk),
    .up_axi_awvalid (s_axi_awvalid),
    .up_axi_awaddr (s_axi_awaddr),
    .up_axi_awready (s_axi_awready),
    .up_axi_wvalid (s_axi_wvalid),
    .up_axi_wdata (s_axi_wdata),
    .up_axi_wstrb (s_axi_wstrb),
    .up_axi_wready (s_axi_wready),
    .up_axi_bvalid (s_axi_bvalid),
    .up_axi_bresp (s_axi_bresp),
    .up_axi_bready (s_axi_bready),
    .up_axi_arvalid (s_axi_arvalid),
    .up_axi_araddr (s_axi_araddr),
    .up_axi_arready (s_axi_arready),
    .up_axi_rvalid (s_axi_rvalid),
    .up_axi_rresp (s_axi_rresp),
    .up_axi_rdata (s_axi_rdata),
    .up_axi_rready (s_axi_rready),
    .up_wreq (up_wreq),
    .up_waddr (up_waddr),
    .up_wdata (up_wdata),
    .up_wack (up_wack_d),
    .up_rreq (up_rreq),
    .up_raddr (up_raddr),
    .up_rdata (up_rdata_d),
    .up_rack (up_rack_d));

endmodule

// ***************************************************************************
// ***************************************************************************
