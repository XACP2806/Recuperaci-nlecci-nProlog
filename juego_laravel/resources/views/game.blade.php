<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>RPG Prolog Engine</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;800&display=swap" rel="stylesheet">
    
    <style>
        body {
            font-family: 'Nunito', sans-serif;
            background-color: #121212; /* Fondo aún más oscuro */
        }
        .console-box {
            background-color: #000;
            border-left: 5px solid #0dcaf0;
            font-family: 'Courier New', Courier, monospace;
        }
        .rpg-card {
            background-color: #1e1e2f;
            border: 1px solid #333344;
        }
    </style>
</head>
<body class="text-light min-vh-100 d-flex align-items-center py-5">

    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-8 col-md-10">
                <div class="card rpg-card text-white shadow-lg rounded-4 overflow-hidden">
                    
                    <div class="card-header bg-black text-center py-4 border-bottom border-secondary">
                        <h1 class="h3 mb-0 text-info fw-bold">Juego en prolog</h1>
                    </div>
                    
                    <div class="card-body p-4 p-md-5">

                        @if(session('error'))
                            <div class="alert alert-danger bg-danger text-white border-0 text-center shadow-sm rounded-3" role="alert">
                                <strong>¡Atención!</strong> {{ session('error') }}
                            </div>
                        @endif

                        <form action="{{ route('game.consultar') }}" method="POST">
                            @csrf

                            <div class="mb-5">
                                <label class="form-label fw-bold text-light fs-5 d-block">Elige tu Equipo:</label>
                                <div class="d-flex flex-wrap gap-2">
                                    @foreach($personajes as $p)
                                        <input type="checkbox" class="btn-check" name="equipo[]" value="{{ $p }}" id="btn_{{ $p }}" 
                                        {{ in_array($p, session('equipoSeleccionado', [])) ? 'checked' : '' }}>
                                        <label class="btn btn-outline-info rounded-pill px-4 shadow-sm" for="btn_{{ $p }}">
                                            {{ $p }}
                                        </label>
                                    @endforeach
                                </div>
                            </div>

                            <div class="row g-4 mb-5">
                                <div class="col-md-6">
                                    <div class="p-4 border border-info border-opacity-25 rounded-3 h-100" style="background-color: rgba(13, 202, 240, 0.05);">
                                        <div class="form-check mb-3">
                                            <input class="form-check-input" type="radio" id="tipo_mision" name="tipo" value="mision" checked>
                                            <label class="form-check-label fw-bold text-info fs-5" for="tipo_mision">Enviar a Misión</label>
                                        </div>
                                        <select name="mision_id" class="form-select bg-dark text-white border-secondary">
                                            @foreach($misiones as $id => $nombre)
                                                <option value="{{ $id }}">{{ $nombre }}</option>
                                            @endforeach
                                        </select>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="p-4 border border-danger border-opacity-25 rounded-3 h-100" style="background-color: rgba(220, 53, 69, 0.05);">
                                        <div class="form-check mb-3">
                                            <input class="form-check-input" type="radio" id="tipo_batalla" name="tipo" value="batalla">
                                            <label class="form-check-label fw-bold text-danger fs-5" for="tipo_batalla">Iniciar Batalla</label>
                                        </div>
                                        <select name="enemigo" class="form-select bg-dark text-white border-secondary">
                                            @foreach($enemigos as $e)
                                                <option value="{{ $e }}">{{ ucfirst($e) }}</option>
                                            @endforeach
                                        </select>
                                    </div>
                                </div>
                            </div>

                            <button type="submit" class="btn btn-info btn-lg w-100 fw-bold shadow text-dark text-uppercase tracking-wide py-3 rounded-3">
                                Ver resultado
                            </button>
                        </form>

                        @if(session('resultado'))
                            <div class="mt-5 console-box p-4 shadow">
                                <p class="mb-0 text-success fs-5">
                                    > {{ session('resultado') }}
                                </p>
                            </div>
                        @endif

                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>