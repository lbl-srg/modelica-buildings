within Buildings.Fluid.Boilers.Data;
record LochinvarKnightXL
  "Boiler efficiency curves for Knight™ XL commercial boiler of Lochinvar"
  extends Buildings.Fluid.Boilers.Data.Generic(
    effCur=
      [0,   294.3,  299.8,  305.4,  310.9,  316.5,  322.0,  327.6,  333.2,  338.7,  344.3;
        0.1,  0.988,  0.981,  0.973,  0.958,  0.940,  0.916,  0.894,  0.877,  0.871,  0.870;
        0.5,  0.982,  0.975,  0.967,  0.953,  0.936,  0.910,  0.890,  0.876,  0.870,  0.869;
          1,  0.978,  0.970,  0.962,  0.948,  0.938,  0.905,  0.888,  0.875,  0.869,  0.868]);

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
end LochinvarKnightXL;
