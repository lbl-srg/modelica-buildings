within Buildings.Examples.ChillerPlant;
model DataCenterContinuousTimeControl
  "Model of data center that approximates the trim and response logic"
  extends Buildings.Examples.ChillerPlant.DataCenterDiscreteTimeControl(redeclare
      BaseClasses.Controls.TrimAndRespondContinuousTimeApproximation triAndRes);
  annotation (
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Examples/ChillerPlant/DataCenterContinuousTimeControl.mos"
        "Simulate and plot"), Documentation(info="<html>
<p>
This model is the chilled water plant with continuous time control.
The trim and response logic is approximated by a PI controller which 
significantly reduces computing time. The model is described at
<a href=\"Buildings.Examples.ChillerPlant\">
Buildings.Examples.ChillerPlant</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
December 5, 2012, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-400,-300},{
            400,300}}),
                    graphics),
    experiment(StartTime=1.30464e+07, StopTime=1.36512e+07));
end DataCenterContinuousTimeControl;
