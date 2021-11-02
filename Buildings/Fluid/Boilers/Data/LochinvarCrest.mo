within Buildings.Fluid.Boilers.Data;
record LochinvarCrest "Example table for boiler efficiency curves"
  extends Buildings.Fluid.Boilers.Data.Generic(
    effCur=
      [0,   294.3,  299.8,  305.4,  310.9,  316.5,  322.0,  327.6,  333.2,  338.7,  344.3;
       0.05,  0.991,  0.984,  0.974,  0.959,  0.940,  0.920,  0.900,  0.887,  0.881,  0.880;
        0.5,  0.988,  0.981,  0.969,  0.952,  0.932,  0.908,  0.890,  0.883,  0.879,  0.878;
          1,  0.969,  0.962,  0.951,  0.935,  0.918,  0.897,  0.885,  0.879,  0.875,  0.874]);

  annotation (
  defaultComponentPrefixes = "parameter",
  Documentation(info="<html>
<p>
Data from
<a href=\"https://www.lochinvar.com/products/commercial-boilers/crest-condensing-boiler/\">
https://www.lochinvar.com/products/commercial-boilers/crest-condensing-boiler/</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
October 12, 2021 by Hongxiang Fu:<br/>
First implementation. 
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2651\">#2651</a>.
</li>
</ul>
</html>"));
end LochinvarCrest;
