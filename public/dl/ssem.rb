class Accumulator
  def initialize
    @value = 0b00000000000000000000000000000000
  end

  def read
    @value
  end

  def send value
    @value = @value - value
  end

  def reset
    @value = 0b00000000000000000000000000000000
  end
end


class Tube
  def initialize
    @store = Array.new 32, 0b00000000000000000000000000000000
  end

  def read address
    @store[extract_address_number address]
  end

  def write address, word
    @store[extract_address_number address] = word & 0b11111111111111111111111111111111
  end

  protected def extract_address_number address
    address & 0b11111
  end


  def set address, position
    write address, read(address) ^ (0b1 << position)
  end

  def configure store
    @store = store
  end


  def show
    STDOUT.write @store
      .map{ |word| ("%032b" % word).reverse }
      .join("\n").gsub(/[01]/, '0' => '. ', '1' => '| ')
  end
end


class SSEM
  def initialize
    @tube = Tube.new
    @acc = Accumulator.new

    @ci = 0b00000000000000000000000000000000
  end

  def run
    begin
      @ci += 0b1
      @pi = @tube.read @ci

      send ((@pi & 0b00000000000000001110000000000000) >> 13).to_s
    end until @halt
  end


  define_method '0' do #JMP
    @ci = @tube.read @pi
  end

  define_method '1' do # JRP
    @ci += @tube.read @pi
  end

  define_method '2' do # LDN
    @acc.reset
    @acc.send @tube.read(@pi)
  end

  define_method '3' do # STO
    @tube.write @pi, @acc.read
  end

  define_method '4' do # SUB
    @acc.send @tube.read(@pi)
  end

  define_method '5' do #SUB
    send '4'
  end

  define_method '6' do # SKN
    @ci += 0b1 if @acc.read[31] == 0b1
  end

  define_method '7' do # STOP
    @halt = true
  end


  def configure description_number
    @tube.configure 31.downto(0).map{ |i| (description_number & 0b11111111111111111111111111111111 << (32 * i)) >> (32 * i) }
  end

  def show
    @tube.show
  end
end


baby = SSEM.new
baby.configure(0x40180000601a0000401a0000601b000040170000801b0000c000000020140000801a00006019000040190000c0000000e0000000401a000080150000601b0000401b0000601a00000016fffffffd0000000100000004fffc00000003ffff00000000000000000000000000000000000000000000000000000000)
baby.run

baby.show
