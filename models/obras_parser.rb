require 'smarter_csv'
require './models/obra_publica.rb'
require 'date'
require 'byebug'

class ObrasParser

  attr_accessor :file_path

  def initialize(file_path)
    @file_path = file_path
  end

  def parse
    raise 'file_path not provided' unless @file_path
    raise 'File does not exist' unless File.file? @file_path

    obras = []
    SmarterCSV.process(@file_path, col_sep: ';') do |row|
      row = row.first
      fecha_inicio = Date.strptime(row[:fecha_inicio],"%d/%m/%Y")
      #byebug
      fecha_fin_planeada = Date.strptime(row[:fecha_fin_planeada],"%d/%m/%Y")
      unless row[:fecha_fin_real].nil?
        fecha_fin_real = Date.strptime(row[:fecha_fin_real],"%d/%m/%Y")
      end
      monto_contrato = row[:monto_contrato]
      obras << ObraPublica.new(row[:id], row[:nombre], row[:etapa], row[:tipo], row[:area_responsable], \
      row[:descripcion], monto_contrato.to_f, row[:comuna], row[:barrio], row[:direccion], fecha_inicio, \
      fecha_fin_planeada, fecha_fin_real, row[:porcentaje_avance], row[:imagen])
    end
    return obras
  end
  
end