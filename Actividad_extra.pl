personaje('Elara', 5, 100).
personaje('Kael', 3, 80).
personaje('Rin', 7, 120).
personaje('Rudeus', 10, 150).
personaje('Zelda', 4, 90).
personaje('Han', 6, 110).

mision(m1, 'Bosque de sombras', 2, 50).
mision(m2, 'Cueva del dragón', 5, 120).
mision(m3, 'Torre arcana', 7, 200).

inventario('Elara', [espada, escudo, pocion]).
inventario('Kael', [arco, flechas]).
inventario('Rin', [varita, grimorio, pocion, amuleto]).
inventario('Rudeus', [espada, grimorio, pocion]).
inventario('Zelda', [varita, pocion]).
inventario('Han', [arco, flechas, pocion]).

arma(espada, 10).
arma(arco, 8).
arma(varita, 12).

enemigo(slime, 7).
enemigo(goblin, 11).
enemigo(dragon, 25).

requiere(m2, escudo).
requiere(m2, pocion).
requiere(m3, grimorio).
requiere(m3, pocion).

puede_aceptar(Equipo, ID_Mision) :-
    encontrar_nivel(Equipo, NivelEquipo),
    mision(ID_Mision, _, Dificultad, _),
    NivelEquipo >= Dificultad.

encontrar_nivel([], 0).
encontrar_nivel([Personaje|Resto], Total) :-
    personaje(Personaje, NivelPersonaje, _),
    encontrar_nivel(Resto, NivelResto),
    Total is NivelPersonaje + NivelResto.

xp_acumulada(0,0).
xp_acumulada(N, Total) :-
    N > 0,
    N1 is N - 1,
    xp_acumulada(N1, Prev),
    Total is Prev + (30*N).

tiene_requerido(Personaje, Objeto) :-
    inventario(Personaje, Lista),
    member(Objeto, Lista).

mismo_nivel(P1, P2) :-
    personaje(P1, N, _),
    personaje(P2, N, _),
    P1 \== P2.

es_balanceado(Personaje) :-
    personaje(Personaje, _, Vida),
    Vida =:= 100.

fusionar_equipo(P1, P2, EquipoFusionado) :-
    inventario(P1, L1),
    inventario(P2, L2),
    append(L1, L2, EquipoFusionado).

dano_personaje([ArmaUsar|_], Dano) :-
    arma(ArmaUsar, DanoBase),
    Dano is DanoBase.

dano_total([], 0).
dano_total([Personaje|Resto], Total) :-
    inventario(Personaje, Inventario),
    dano_personaje(Inventario, DanoPersonaje),
    dano_total(Resto, DanoResto),
    Total is DanoPersonaje + DanoResto.

equipo_tiene_objeto(Equipo, Objeto) :-
    member(Personaje, Equipo),
    tiene_requerido(Personaje, Objeto).

cumple_requisitos_objetos(_, []).
cumple_requisitos_objetos(Equipo, [Obj|Resto]) :-
    equipo_tiene_objeto(Equipo, Obj),
    cumple_requisitos_objetos(Equipo, Resto).

mision_viable(Equipo, ID_Mision, Mensaje) :-
    puede_aceptar(Equipo, ID_Mision),
    findall(Obj, requiere(ID_Mision, Obj), Requisitos),
    cumple_requisitos_objetos(Equipo, Requisitos),
    generar_reporte_mision(Equipo, ID_Mision, Mensaje).
mision_viable(Equipo, ID_Mision, Mensaje) :-
    mision(ID_Mision, Nombre, _, _),
    generar_nombre_equipo(Equipo, NombreEquipo),
    atomic_list_concat([NombreEquipo, ' no cumple con los requisitos de nivel u objetos para entrar a ', Nombre, '.'], Mensaje).



tiempo(presente). tiempo(pasado). tiempo(futuro).

persona(primera). persona(segunda). persona(tercera).

numero(singular). numero(plural).

ser(presente, tercera, singular, " es").
ser(pasado, tercera, singular, " fue").
ser(futuro, tercera, singular, " será").
ser(presente, primera, singular, " soy").
ser(presente, primera, plural, " somos").
ser(presente, tercera, plural, " son").
ser(pasado, tercera, plural, " fueron").
ser(futuro, tercera, plural, "serán").

adjetivo_capaz(singular, " capaz").
adjetivo_capaz(plural, " capaces").

adjetivo_hizo(singular, " hizo").
adjetivo_hizo(plural, " hicieron").

adjetivo_derrotar(singular, " derroto").
adjetivo_derrotar(plural, " derrotaron").

conjugar_accion(Verbo, Tiempo, Persona, Numero, Conjugacion) :-
    tiempo(Tiempo),
    persona(Persona),
    numero(Numero),
    (Verbo = "ser" ->
        ser(Tiempo, Persona, Numero, R),
        Conjugacion = R
    ;   Conjugacion = Verbo).

generar_nombre_equipo([], "Equipo vacío").
generar_nombre_equipo([Personaje], NombreEquipo) :-
    personaje(Personaje, _, _),
    NombreEquipo = Personaje.
generar_nombre_equipo([Personaje|Resto], NombreEquipo) :-
    personaje(Personaje, _, _),
    generar_nombre_equipo(Resto, NombreResto),
    atomic_list_concat([Personaje, ' y ', NombreResto], NombreEquipo).

definir_numero([_], singular).
definir_numero([_, _ | _], plural).


generar_reporte_mision(Equipo, MisionID, Mensaje) :-
    puede_aceptar(Equipo, MisionID),
    mision(MisionID, Nombre, _, XP),
    definir_numero(Equipo, Numero),
    conjugar_accion("ser", presente, tercera, Numero, FormaVerbal),
    adjetivo_capaz(Numero, ConjugacionCapaz),
    generar_nombre_equipo(Equipo, NombreEquipo),
    atomic_list_concat([NombreEquipo, ' ', FormaVerbal, ' ', ConjugacionCapaz, ' de completar ', Nombre, ' por ', XP, ' XP.'], Mensaje).

generar_reporte_batalla(Equipo, Enemigo, Mensaje):-
    enemigo(Enemigo, VidaEnemigo),
    dano_total(Equipo, DanoTotal),
    generar_nombre_equipo(Equipo, NombreEquipo),
    definir_numero(Equipo, Numero),
    adjetivo_hizo(Numero, ConjugacionHizo),
    adjetivo_derrotar(Numero, ConjugacionDerrotar),
    (DanoTotal >= VidaEnemigo ->
        Resultado = ""
    ;   Resultado = " no"
    ),
   atomic_list_concat([NombreEquipo, ConjugacionHizo, ' ', DanoTotal, ' de danio por lo que', Resultado, ConjugacionDerrotar, ' al ', Enemigo, '.'], Mensaje).