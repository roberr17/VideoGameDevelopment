shader_type canvas_item;

// 'uniform' hace que puedas editarlos desde el Inspector
uniform float wave_amplitude: hint_range(0.0, 20.0) = 5.0;  // Qué tan altas son las olas
uniform float wave_frequency: hint_range(0.0, 20.0) = 10.0; // Cuántas olas hay
uniform float wave_speed: hint_range(0.0, 5.0) = 1.0;      // Qué tan rápido se mueven

// Usamos la función vertex() para mover los vértices del sprite [cite: 696]
void vertex() {
	// Añadimos un offset a la 'Y' de cada vértice
	// Usamos sin() con el 'TIME' global para la animación [cite: 698]
	// Usamos UV.x para que la ola sea consistente a lo ancho
	VERTEX.y += sin(UV.x * wave_frequency + TIME * wave_speed) * wave_amplitude;
}
