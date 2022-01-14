within Buildings.Fluid.HeatPumps;
model Carnot_TCon
  "Heat pump with prescribed condenser leaving temperature and performance curve adjusted based on Carnot efficiency"
 extends Buildings.Fluid.Chillers.BaseClasses.PartialCarnot_T(
   final COP_is_for_cooling = false,
   final QEva_flow_nominal = -QCon_flow_nominal*(COP_nominal-1)/COP_nominal,
   PEle(y=QCon_flow/COP),
   redeclare HeatExchangers.Heater_T con(
    final from_dp=from_dp1,
    final dp_nominal=dp1_nominal,
    final linearizeFlowResistance=linearizeFlowResistance1,
    final deltaM=deltaM1,
    final QMax_flow=QCon_flow_max,
    final tau=tau1,
    final T_start=T1_start,
    final energyDynamics=energyDynamics,
    final homotopyInitialization=homotopyInitialization),
   redeclare HeatExchangers.HeaterCooler_u eva(
    final from_dp=from_dp2,
    final dp_nominal=dp2_nominal,
    final linearizeFlowResistance=linearizeFlowResistance2,
    final deltaM=deltaM2,
    final tau=tau2,
    final T_start=T2_start,
    final energyDynamics=energyDynamics,
    final homotopyInitialization=homotopyInitialization,
    final Q_flow_nominal=QEva_flow_nominal));

  parameter Modelica.Units.SI.HeatFlowRate QCon_flow_max(min=0) = Modelica.Constants.inf
    "Maximum heat flow rate for heating (positive)";

  Modelica.Blocks.Interfaces.RealInput TSet(unit="K")
    "Condenser leaving water temperature"
    annotation (Placement(transformation(extent={{-140,70},{-100,110}})));

protected
  Modelica.Blocks.Math.Gain yEva(final k=1/QEva_flow_nominal)
    "Normalized evaporator heat flow rate"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  Modelica.Blocks.Math.Add QEva_flow_internal(final k1=-1)
    "Heat removed by evaporator"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
initial equation
  assert(QCon_flow_nominal > 0, "Parameter QCon_flow_nominal must be positive.");
  assert(COP_nominal > 1, "The nominal COP of a heat pump must be bigger than one.");


equation
  connect(TSet, con.TSet) annotation (Line(points={{-120,90},{-80,90},{-80,90},{
          -80,68},{-12,68}}, color={0,0,127}));
  connect(con.Q_flow, QCon_flow) annotation (Line(points={{11,68},{80,68},{80,90},
          {110,90}}, color={0,0,127}));
  connect(QEva_flow_internal.u1, con.Q_flow) annotation (Line(points={{-2,-24},{
          -10,-24},{-10,0},{30,0},{30,68},{11,68}},   color={0,0,127}));
  connect(QEva_flow_internal.u2, PEle.y) annotation (Line(points={{-2,-36},{-2,-36},
          {-20,-36},{-20,-14},{90,-14},{90,0},{61,0}}, color={0,0,127}));
  connect(QEva_flow_internal.y, yEva.u)
    annotation (Line(points={{21,-30},{30,-30},{38,-30}},
                                                 color={0,0,127}));
  connect(QEva_flow, QEva_flow_internal.y) annotation (Line(points={{110,-90},{78,
          -90},{28,-90},{28,-30},{21,-30}}, color={0,0,127}));
  connect(yEva.y, eva.u) annotation (Line(points={{61,-30},{70,-30},{70,-54},{12,
          -54}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},
            {100,100}}),
            graphics={
        Text(
          extent={{-148,156},{-92,114}},
          textColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="TCon"),
        Line(points={{-100,90},{-80,90},{-80,84},{80,84},{80,64}},
                                                    color={0,0,255})}),
defaultComponentName="heaPum",
Documentation(info="<html>
<p>
This is a model of a heat pump whose coefficient of performance COP changes
with temperatures in the same way as the Carnot efficiency changes.
The control input is the setpoint of the condenser leaving temperature, which
is met exactly at steady state if the heat pump has sufficient capacity.
</p>
<p>
The model allows to either specify the Carnot effectivness
<i>&eta;<sub>Carnot,0</sub></i>, or
a <i>COP<sub>0</sub></i>
at the nominal conditions, together with
the evaporator temperature <i>T<sub>eva,0</sub></i> and
the condenser temperature <i>T<sub>con,0</sub></i>, in which
case the model computes the Carnot effectivness as
</p>
<p align=\"center\" style=\"font-style:italic;\">
&eta;<sub>Carnot,0</sub> =
  COP<sub>0</sub>
&frasl;  (T<sub>con,0</sub> &frasl; (T<sub>con,0</sub>-T<sub>eva,0</sub>)).
</p>
<p>
The heat pump COP is computed as the product
</p>
<p align=\"center\" style=\"font-style:italic;\">
  COP = &eta;<sub>Carnot,0</sub> COP<sub>Carnot</sub> &eta;<sub>PL</sub>,
</p>
<p>
where <i>COP<sub>Carnot</sub></i> is the Carnot efficiency and
<i>&eta;<sub>PL</sub></i> is a polynomial in heating part load ratio <i>y<sub>PL</sub></i>
that can be used to take into account a change in <i>COP</i> at part load
conditions.
This polynomial has the form
</p>
<p align=\"center\" style=\"font-style:italic;\">
  &eta;<sub>PL</sub> = a<sub>1</sub> + a<sub>2</sub> y<sub>PL</sub> + a<sub>3</sub> y<sub>PL</sub><sup>2</sup> + ...
</p>
<p>
where the coefficients <i>a<sub>i</sub></i>
are declared by the parameter <code>a</code>.
</p>
<p>
On the <code>Dynamics</code> tag, the model can be parametrized to compute a transient
or steady-state response.
The transient response of the model is computed using a first
order differential equation for the evaporator and condenser fluid volumes.
The heat pump outlet temperatures are equal to the temperatures of these lumped volumes.
</p>
<h4>Typical use and important parameters</h4>
<p>
When using this component, make sure that the condenser has sufficient mass flow rate.
Based on the evaporator mass flow rate, temperature difference and the efficiencies,
the model computes how much heat will be removed by to the evaporator.
If the mass flow rate is too small, very low outlet temperatures can result, possibly below freezing.
</p>
<p>
The condenser heat flow rate <code>QCon_flow_nominal</code> is used to assign
the default value for the mass flow rates, which are used for the pressure drop
calculations.
It is also used to compute the part load efficiency.
Hence, make sure that <code>QCon_flow_nominal</code> is set to a reasonable value.
</p>
<p>
The maximum heating capacity is set by the parameter <code>QCon_flow_max</code>,
which is by default set to infinity.
</p>
<p>
The coefficient of performance depends on the
evaporator and condenser leaving temperature
since otherwise the second law of thermodynamics may be violated.
</p>
<h4>Notes</h4>
<p>
For a similar model that can be used as a chiller, see
<a href=\"modelica://Buildings.Fluid.Chillers.Examples.Carnot_TEva\">
Buildings.Fluid.Chillers.Examples.Carnot_TEva</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
January 3, 2017, by Michael Wetter:<br/>
Removed parameters
<code>effInpEva</code> and <code>effInpCon</code>
and updated documentation.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/497\">
issue 497</a>.
</li>
<li>
August 8, 2016, by Michael Wetter:<br/>
Changed default temperature to compute COP to be the leaving temperature as
use of the entering temperature can violate the 2nd law if the temperature
lift is small.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/497\">
Annex 60, issue 497</a>.
</li>
<li>
November 25, 2015 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Carnot_TCon;
