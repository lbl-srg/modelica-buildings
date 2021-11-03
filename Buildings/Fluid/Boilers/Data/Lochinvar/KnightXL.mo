within Buildings.Fluid.Boilers.Data.Lochinvar;
record KnightXL
  "Boiler efficiency curves for Knight™ XL commercial boiler of Lochinvar"
  extends Buildings.Fluid.Boilers.Data.Generic(
    effCur=
      [0,   294.226732673267, 299.785726072607, 305.344719471947, 310.891107444078, 316.424889988999, 322.009094242757, 327.542876787678, 333.101870187018, 338.660863586358, 344.219856985698;
       0.1,0.988111888111888,0.981118881118881,0.972377622377622,0.958041958041957,0.939510489510489,0.915209790209790,0.892657342657342,0.876573426573426,0.870804195804195,0.869230769230769;
       0.5,0.982167832167832,0.975174825174825,0.966433566433566,0.952622377622377,0.934090909090909,0.909615384615384,0.889860139860139,0.875699300699300,0.870279720279720,0.868881118881118;
         1,0.977097902097902,0.970279720279720,0.961363636363636,0.946853146853146,0.926923076923076,0.904195804195804,0.887237762237762,0.874650349650349,0.869055944055944,0.867832167832167]);
//      [0,   294.3,  299.8,  305.4,  310.9,  316.5,  322.0,  327.6,  333.2,  338.7,  344.3;
//        0.1,  0.988,  0.981,  0.973,  0.958,  0.940,  0.916,  0.894,  0.877,  0.871,  0.870;
//        0.5,  0.982,  0.975,  0.967,  0.953,  0.936,  0.910,  0.890,  0.876,  0.870,  0.869;
//          1,  0.978,  0.970,  0.962,  0.948,  0.928,  0.905,  0.888,  0.875,  0.869,  0.868]);

  annotation (
  defaultComponentPrefixes = "parameter",
  Documentation(info="<html>
<p>
Data from
<a href=\"https://www.lochinvar.com/products/commercial-boilers/knight-xl/\">
https://www.lochinvar.com/products/commercial-boilers/knight-xl/</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
November 1, 2021 by Hongxiang Fu:<br/>
First implementation. 
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2651\">#2651</a>.
</li>
</ul>
</html>"));
end KnightXL;
