<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class GameController extends Controller
{
    public function index()
    {
        $personajes = ['Elara', 'Kael', 'Rin', 'Rudeus', 'Zelda', 'Han'];
        $misiones = [
            'm1' => 'Bosque de sombras',
            'm2' => 'Cueva del dragón',
            'm3' => 'Torre arcana'
        ];
        $enemigos = ['slime', 'goblin', 'dragon'];

        return view('game', compact('personajes', 'misiones', 'enemigos'));
    }

    public function consultar(Request $request)
    {
        $tipo = $request->input('tipo'); 
        $equipoArray = $request->input('equipo', []);
        
        if (empty($equipoArray)) {
            return back()->with('error', '¡Debes seleccionar al menos un personaje para formar el equipo!');
        }

        $equipoProlog = "['" . implode("','", $equipoArray) . "']";
        

        $pathProlog = "C:\\Users\\pxcm\\OneDrive\\Documentos\\UEES\\Lenguajes de programacion\\RecuperaciónlecciónProlog\\Actividad_extra.pl";

        if ($tipo === 'mision') {
            $misionId = $request->input('mision_id');
            $consulta = "mision_viable($equipoProlog, $misionId, M), write(M), halt.";
        } else {
            $enemigo = $request->input('enemigo');
            $consulta = "generar_reporte_batalla($equipoProlog, $enemigo, M), write(M), halt.";
        }

        $comando = "swipl -q -s " . escapeshellarg($pathProlog) . " -g " . escapeshellarg($consulta);

        $resultado = shell_exec($comando);

        return back()->with([
            'resultado' => $resultado ?? 'No se obtuvo respuesta del motor Prolog.',
            'equipoSeleccionado' => $equipoArray
        ]);
    }
}