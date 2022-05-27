package randlut

import chisel3._
import chisel3.stage.ChiselStage

class RandomLUTPipe(index_bits: Int, output_bits: Int) extends Module {
  val io = IO(new Bundle {
    val in  = Input(UInt(index_bits.W))
    val out = Output(UInt(output_bits.W))
  })

  val lut_in = RegNext(io.in)
  val lut = Module(new RandomLUT(index_bits, output_bits))
  lut.io.in := lut_in
  val lut_out = RegNext(lut.io.out)

  io.out := lut_out
}

object RandomLUTPipeDriver extends App {
  (new ChiselStage).emitVerilog(new RandomLUTPipe(12, 12), args)
}
