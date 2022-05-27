package randlut

import chisel3._
import chisel3.stage.ChiselStage

class RandomLUT(index_bits: Int, output_bits: Int) extends Module {
  val io = IO(new Bundle {
    val in  = Input(UInt(index_bits.W))
    val out = Output(UInt(output_bits.W))
  })

  val rand = scala.util.Random
  val num_entries: Int = math.pow(2, index_bits).toInt
  val max_output: Int = math.pow(2, output_bits).toInt
  val rand_seq: Seq[Int] = Seq.tabulate(num_entries)(_ => rand.nextInt(max_output))
  val rand_seq_chisel: Seq[Data] = rand_seq.map(a => a.U(output_bits.W))

  val lut = WireInit(VecInit(rand_seq_chisel))

  println(s"Total Size of LUT: ${num_entries * output_bits / 8.0 / 1024.0} KB")

  io.out := lut(io.in)
}

object RandomLUTDriver extends App {
  (new ChiselStage).emitVerilog(new RandomLUT(12, 12), args)
}
