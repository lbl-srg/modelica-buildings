within Buildings.Airflow.Multizone.Validation;
model ThreeRoomsContamDiscretizedDoor
  "Model with three rooms for the validation of the multizone air exchange models"
  extends Buildings.Airflow.Multizone.Validation.ThreeRoomsContam(
    redeclare Buildings.Airflow.Multizone.DoorDiscretizedOperable dooOpeClo(
    redeclare package Medium = Medium,
    LClo=20*1E-4,
    wOpe=1,
    hOpe=2.2,
    CDOpe=0.78,
    CDClo=0.78,
    nCom=10,
    hA=3/2,
    hB=3/2,
    dp_turbulent(displayUnit="Pa") = 0.01));
  Modelica.Blocks.Sources.Constant open1(k=1)
    "Constant signal for door opening"
    annotation (Placement(
        transformation(extent={{-40,-30},{-20,-10}})));
equation
  connect(open1.y, dooOpeClo.y) annotation (Line(points={{-19,-20},{-12,-20},{-12,
          -44},{-2,-44},{-2,-45}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-200,-150},{260,
            200}})),
experiment(Tolerance=1e-06, StopTime=3600),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Airflow/Multizone/Validation/ThreeRoomsContamDiscretizedDoor.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This model is identical to
<a href=\"modelica://Buildings.Airflow.Multizone.Validation.ThreeRoomsContam\">
Buildings.Airflow.Multizone.Validation.ThreeRoomsContam</a>
except that it uses a different door model.
</p>
<p>
This model has been used for a comparative model validation between CONTAM and
the <code>Buildings</code> library.
See Wetter (2006) for details of the validation.
</p>
<h4>References</h4>
<p>
Michael Wetter.
<a href=\"modelica://Buildings/Resources/Images/Airflow/Multizone/Wetter-airflow-2006.pdf\">
Multizone Airflow Model in Modelica.</a>
Proc. of the 5th International Modelica Conference, p. 431-440. Vienna, Austria, September 2006.
</p>
</html>", revisions="<html>
<ul>
<li>
October 9, 2020, by Michael Wetter:<br/>
Refactored model to use the base class
<a href=\"modelica://Buildings.Airflow.Multizone.Validation.ThreeRoomsContam\">
Buildings.Airflow.Multizone.Validation.ThreeRoomsContam</a>.
</li>
<li>
May 15, 2019, by Jianjun Hu:<br/>
Replaced fluid source. This is for 
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1072\"> #1072</a>.
</li>
<li>
December 22, 2014 by Michael Wetter:<br/>
Removed <code>Modelica.Fluid.System</code>
to address issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/311\">#311</a>.
</li>
<li>
June 26, 2014, by Michael Wetter:<br/>
Set the initial conditions to be fixed to avoid a translation warning.
This required adding a heat conductor between each volume and its prescribed
temperature in order to avoid an overdetermined system of equations.
</li>
<li>
November 10, 2011, by Michael Wetter:<br/>
Added documentation.
</li>
</ul>
</html>"));
end ThreeRoomsContamDiscretizedDoor;
