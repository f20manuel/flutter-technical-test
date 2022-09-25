# fluttertest

Esta es una prueba de darrollo en flutter para [Leal Colombia S.A.S.](https://leal.co/)

## Notas de versión

### Novedades

Cumpliendo con los requerimientos de la prueba, este proyecto tiene las siguientes características:

- RiverPod como manejador de estados.
- Se aplicó pruebas unitarios durante todo el proceso de login y algunas pruebas básicas en el resto de pantallas.
- Se implemento buenas practicas en la construcción del software.
- Se implemento una arquitectura ordenada muy parecida al patron de diseño "MVC".

### Fallas conocidas

A continuación: una lista con las fallas conocidas en esta versión.

- El ícono de "me gusta" aunque funciona si se selecciona antes de entra a la sessión de detalles de la series puede dejar de funcionar por un lapso corto de tiempo.
- A veces el api de [The Movie DB](https://themovidedb.org/) puede dejar campos nulos por lo que algunas veces la app puede dejar de mostrar información.

## DEMO y Capturas de pantalla:

|||||
|--|--|--|--|
|![demo](/demo/demo.gif "Prueba flutter")|![login](/screenshots/Screenshot_20220925_102856.png "Login")|![login 2](/screenshots/Screenshot_20220925_102854.png "Login 2")|![home](/screenshots/Screenshot_20220925_102852.png "home")|
|![recommendations](/screenshots/Screenshot_20220925_102849.png "recommendations")|![favorites](/screenshots/Screenshot_20220925_102844.png "favorites")|![recent](/screenshots/Screenshot_20220925_102839.png "recent")|![Series details](/screenshots/Screenshot_20220925_102846.png "series details")|
||![Episode details](/screenshots/Screenshot_20220925_102847.png "episode details")|![recent list](/screenshots/Screenshot_20220925_102743.png "recent list")||
