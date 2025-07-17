within Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Frosting.BaseClasses;
partial model PartialIcingFactor "Partial model to calculate the icing factor"
  extends Modelica.Blocks.Icons.Block;
  parameter Modelica.Units.SI.SpecificHeatCapacity cpEva
    "Evaporator medium specific heat capacity"
    annotation (Dialog(tab="Advanced", group="Medium properties"));

  Buildings.Fluid.HeatPumps.ModularReversible.BaseClasses.RefrigerantMachineControlBus sigBus
    "Bus-connector used in a heat pump" annotation (Placement(transformation(
        extent={{-15,-14},{15,14}},
        rotation=0,
        origin={-101,0})));
  Modelica.Blocks.Interfaces.RealOutput iceFac(final unit="1", min=0, max=1)
    "Icing factor from 0 to 1 to estimate influence of icing"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,0})));
protected
 Modelica.Blocks.Sources.Constant constNoFro(final k=1)
    "Disable frosting"
  annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
 Modelica.Blocks.Sources.BooleanConstant conIsAirSource(final k=cpEva < 1500)
    "=true if medium is air"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Modelica.Blocks.Logical.Switch swi
    "Switch between disable and enable calculation"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
equation
  connect(constNoFro.y, swi.u3) annotation (Line(points={{41,-30},{50,-30},{50,-8},
          {58,-8}}, color={0,0,127}));
  connect(swi.y, iceFac)
    annotation (Line(points={{81,0},{110,0}}, color={0,0,127}));
  connect(conIsAirSource.y, swi.u2)
    annotation (Line(points={{41,0},{58,0}}, color={255,0,255}));
   annotation (Icon(coordinateSystem(preserveAspectRatio=false)),
   Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
Partial model to calculate the icing factor based on the data available in the
  signal bus <code>sigBus</code> of the heat pump.
</p>
<p>
The icing factor is a heat transfer modifier between <i>0</i> and <i>1</i>, whereas
<i>0</i> indicates no heat transfer occurs and
<i>1</i> indicates the heat transfer is unaffected.
</p>
<p>
  See the documentation of <a href=
  \"modelica://Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.PartialRefrigerantCycle\">
  Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.PartialRefrigerantCycle</a>
  for further information.
</p>
</html>", revisions="<html><ul>
  <li>
    Mai 2, 2025, by Fabian Wuellhorst:<br/>
    Disable if not air souce
    <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1975\">IBPSA #1975</a>
  </li>
  <li>
    <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
  </li>
</ul>
</html>"));
end PartialIcingFactor;
