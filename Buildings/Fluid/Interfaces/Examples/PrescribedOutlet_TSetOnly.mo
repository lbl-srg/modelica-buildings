within Buildings.Fluid.Interfaces.Examples;
model PrescribedOutlet_TSetOnly "Test model for prescribed outlet state"
  extends Modelica.Icons.Example;
  extends Buildings.Fluid.Interfaces.Examples.BaseClasses.PrescribedOutletState(
    steSta(use_X_wSet=false),
    heaHigPow(use_X_wSet=false),
    cooLimPow(use_X_wSet=false),
    heaCooUnl(use_X_wSet=false));

equation
  connect(setHeaHigPow.y[1], heaHigPow.TSet) annotation (Line(points={{-39,120},
          {-20,120},{-20,94},{-12,94}}, color={0,0,127}));
  connect(setCooLimPow.y[1], cooLimPow.TSet) annotation (Line(points={{-39,40},{
          -26,40},{-26,8},{-12,8}}, color={0,0,127}));
  connect(setHeaCooUnl.y[1], heaCooUnl.TSet) annotation (Line(points={{-39,-30},
          {-26,-30},{-26,-52},{-12,-52}}, color={0,0,127}));
  connect(setHeaCooUnl.y[1], steSta.TSet) annotation (Line(points={{-39,-30},{-26,
          -30},{-26,-82},{-12,-82}}, color={0,0,127}));


  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,
            -120},{120,160}})),
    experiment(Tolerance=1e-6, StopTime=1200),
__Dymola_Commands(file= "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Interfaces/Examples/PrescribedOutlet_TSetOnly.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Model that demonstrates
<a href=\"modelica://Buildings.Fluid.Interfaces.PrescribedOutlet\">
Buildings.Fluid.Interfaces.PrescribedOutlet</a>
with temperature setpoint.
</p>
</html>", revisions="<html>
<ul>
<li>
May 3, 2017, by Michael Wetter:<br/>
Refactored model to allow <code>X_wSet</code> as an input.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/763\">#763</a>.
</li>
<li>
November 11, 2014, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end PrescribedOutlet_TSetOnly;
