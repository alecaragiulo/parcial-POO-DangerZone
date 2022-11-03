

class Empleado	{
	var salud = 100
	var property habilidades = []
	var puesto

	//method completarMision()
	
	method estadoIncapacitado() = salud < self.saludCritica()
	
	method saludCritica() = puesto.saludCritica()
	
	method puedeUsarHabilidad(habilidad) = !self.estadoIncapacitado() && self.tieneHabilidad(habilidad)
	
	method tieneHabilidad(habilidad) = habilidades.contains(habilidad)
	
	method recibirDanio(peligrosidad) = (salud -= peligrosidad).max(0)
	
	method completarMision(mision){
		
		if (salud > 0) 
		
			puesto.premio(mision,self)
	}
	
	method aprender(habilidad) = habilidades.add(habilidad)
	
}
	

class Jefe inherits Empleado	{
	var subordinados = []
	
	override method tieneHabilidad(habilidad) = super(habilidad) || self.algunSubordinadoTengaLaHabilidad(habilidad)
	
	method algunSubordinadoTengaLaHabilidad(habilidad) = subordinados.any({subordinado => subordinado.puedeUsarHabilidad(habilidad)})
	
}



object espia {   //quedaria como estado puesto que no tiene algo que le cambie el estado
	
	method saludCritica() = 15
	
	method premio(mision,empleado){
		
		mision.enseniarHabilidades(empleado)
	}
	
}

 
class Oficinista 	{
	var estrellas
	
	method saludCritica() = (40 - 5 * estrellas).max(0)
	
	method premio(mision,empleado) {
		estrellas = estrellas +  1
		
		if (estrellas == 3) empleado.puesto(espia)	
	}
}

class Mision {
	var peligrosidad
	var habilidadesRequeridas = []
	
	method puedeSerRealizadaPor(designado){
		
		if (!self.reuneHabilidadesRequeridas(designado)) 
		
			self.error("no se puede realizar la mision")
			
		else designado.recibirDanio(peligrosidad) && designado.completarMision(self)
	}
		
	method reuneHabilidadesRequeridas(designado) = habilidadesRequeridas.all({habilidad => designado.puedeUsarHabilidad(habilidad)})
	
	method enseniarHabilidades(empleado) = self.habilidadesQueNoTiene(empleado).forEach({habilidad => empleado.aprender(habilidad)})
	
	method habilidadesQueNoTiene(empleado) = habilidadesRequeridas.filter({habilidad =>!empleado.tieneHabilidad(habilidad)})
	
}

class Equipo {
	
	var empleados = []
	
	method puedeUsarCadaHabilidad(habilidad) = empleados.any({empleado => empleado.puedeUsarHabilidad(habilidad)})
	
	method recibirDanio(cantidad) = empleados.forEach({empleado => empleado.recibirDanio(cantidad/3)})
	
	method premio(mision) = empleados.forEach({empleado => empleado.completarMision(mision)})
	
	
}

