require 'byebug'
require 'date'
require './models/obras_parser.rb'

class ObraPublica

  attr_reader :id
  attr_accessor :nombre, :etapa, :tipo, :area_responsable, :descripcion, :monto_contrato, 
  :comuna, :barrio, :direccion, :fecha_inicio, :fecha_fin_planeada, :fecha_fin_real, :porcentaje_avance, :imagen

  def initialize(id, nombre, etapa, tipo, area_responsable, descripcion, monto_contrato, 
    comuna, barrio, direccion, fecha_inicio, fecha_fin_planeada, fecha_fin_real, porcentaje_avance, imagen)

    @id = id.to_i
    @nombre = nombre
    @etapa = etapa
    @tipo = tipo
    @area_responsable = area_responsable
    @descripcion = descripcion
    @monto_contrato = monto_contrato.to_i
    @comuna = comuna.to_i
    @barrio = barrio
    @direccion = direccion
    @fecha_inicio = fecha_inicio.to_s
    @fecha_fin_planeada = fecha_fin_planeada.to_s
    @fecha_fin_real = fecha_fin_real.to_s
    #byebug
    begin
      @fecha_inicio = Date.parse(@fecha_inicio).to_s unless @fecha_inicio.empty?
      @fecha_fin_planeada = Date.parse(@fecha_fin_planeada).to_s unless @fecha_fin_planeada.empty?
      @fecha_fin_real = Date.parse(@fecha_fin_real).to_s unless @fecha_fin_real.empty?
    rescue => exception
      raise InputException.new("ID:#{@id} - El formato de fecha ingresado no es válido")
    end
    @porcentaje_avance = porcentaje_avance.to_i
    @imagen = imagen
    etapas = ['En Ejecución', 'En Licitación', 'En Proyecto', 'Finalizada']
    raise InputException.new("ID:#{@id} - La etapa ingresada no coincide con las opciones permitidas") unless etapas.include?(@etapa)
    raise InputException.new("ID:#{@id} - El porcentaje de avance ingresado no está permitido") unless (@porcentaje_avance >= 0 && @porcentaje_avance <= 100)
    raise InputException.new("ID:#{@id} - El monto ingresado no puede ser negativo") unless (@monto_contrato >= 0)
    raise InputException.new("ID:#{@id} - El número de comuna debe estar entre 1 y 15") unless (@comuna >= 1 && @comuna <=15)
    raise InputException.new("ID:#{@id} - La descripción no puede contener más de 2000 caracteres") unless (@descripcion.length <= 2000)
    unless (@fecha_inicio.empty? || @fecha_fin_planeada.empty?)
      raise InputException.new("ID:#{@id} - La fecha final estimada debe ser posterior a la fecha de inicio") unless @fecha_inicio < @fecha_fin_planeada
    end
    unless (@fecha_inicio.empty? || @fecha_fin_real.empty?)
      raise InputException.new("ID:#{@id} - La fecha de finalización debe ser posterior a la fecha de inicio") unless @fecha_inicio < @fecha_fin_real
    end
    if @etapa == 'Finalizada' then 
      raise InputException.new("ID:#{@id} - Toda obra FINALIZADA debe tener un porcentaje de avance del 100% y una fecha de finalización real acorde") unless (@porcentaje_avance == 100 && ! @fecha_fin_real.empty?)
    end
    if @porcentaje_avance == 100 then 
      raise InputException.new("ID:#{@id} - El 100% de avance sólo puede ser utilizado en obras FINALIZADAS") unless @etapa == 'Finalizada'
    end
    if ! @fecha_fin_real.empty? then 
      raise InputException.new("ID:#{@id} - La fecha de finalización real sólo se debe utilizar en obras FINALIZADAS") unless @etapa == 'Finalizada'
    end
  end

end