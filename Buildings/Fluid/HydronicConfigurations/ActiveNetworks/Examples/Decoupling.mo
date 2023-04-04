within Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples;
model Decoupling
  "Model illustrating the operation of a decoupling circuit"
  extends BaseClasses.PartialDecoupling(del2(nPorts=4), mode(table=[0,0; 6,0; 6,
          2; 15,2; 15,1; 22,1; 22,0; 24,0]),
    T1Set(nin=3));

equation
  connect(con.port_b2, jun.port_1)
    annotation (Line(points={{4,20},{4,60},{10,60}}, color={0,127,255}));
  connect(con.port_a2, del2.ports[4])
    annotation (Line(points={{16,20},{16,40},{40,40}},   color={0,127,255}));
   annotation (experiment(
    StopTime=86400,
    Tolerance=1e-6),
    __Dymola_Commands(file=
    "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HydronicConfigurations/ActiveNetworks/Examples/Decoupling.mos"
    "Simulate and plot"),
    Documentation(info="<html>
<p>
This model represents a change-over system where the configuration
<a href=\"modelica://Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Decoupling\">
Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Decoupling</a>
serves as the interface between a variable flow primary circuit
and a variable flow consumer circuit operated in change-over.
For a given operating mode, both the primary circuit and the
consumer circuit have a constant supply temperature.
</p>
<p>
The model illustrates how the primary flow rate varies with the
secondary flow rate, yielding a nearly constant bypass mass flow rate.
</p>
</html>", revisions="<html>
<ul>
<li>
June 30, 2022, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end Decoupling;
