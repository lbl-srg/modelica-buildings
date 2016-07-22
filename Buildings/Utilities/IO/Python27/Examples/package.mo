within Buildings.Utilities.IO.Python27;
package Examples "Collection of models that illustrate model use and test models"
  extends Modelica.Icons.ExamplesPackage;

model CymdistComm
  "Model calling a Python script to communicate with Cymdist"
  extends Modelica.Icons.Example;
  extends Modelica.Icons.UnderConstruction;
  parameter Modelica.SIunits.Time samplePeriod = 30
    "Sample period for communication";
  Modelica.Blocks.Sources.Constant const[3](each k=1)
    annotation (Placement(transformation(extent={{-84,-10},{-64,10}})));
  Python27.Cymdist pyt(inFileName="/home/thierry/input.txt", outFileName=
        "/home/thierry/input.txt",
    samplePeriod=300)
    annotation (Placement(transformation(extent={{-8,-10},{12,10}})));
  Modelica.Blocks.Interfaces.RealOutput y[3]
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
equation
  connect(const.y, pyt.uR)
    annotation (Line(points={{-63,0},{-24,0},{-10,0}}, color={0,0,127}));
  connect(pyt.yR, y)
    annotation (Line(points={{13,0},{13,0},{110,0}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
            Documentation(info="<html>
</html>",   revisions = "<html>
            <ul>
            <li>Sep 9, 2013 by Peter Grant:<br/>
            First implementation.</li>
            </ul>
            </html>"));
end CymdistComm;

annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains examples for the use of models that can be found in
<a href=\"modelica://Buildings.Utilities.IO.Python27\">
Buildings.Utilities.IO.Python27</a>.
</p>
</html>"));
end Examples;
