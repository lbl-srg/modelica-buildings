within Buildings.Fluid.DXSystems.Cooling.AirSource.Validation.Data;
record SingleSpeedHeating
  "Data record for DX heating coil in validation models"
  extends
    Buildings.Fluid.DXSystems.Heating.AirSource.Data.Generic.Coil(
    sta={
        Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.Stage(
        spe=1800/60,
        nomVal=
          Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=15000,
          COP_nominal=2.75,
          SHR_nominal=1,
          m_flow_nominal=0.782220983308365,
          TEvaIn_nominal=273.15 + 6,
          TConIn_nominal=273.15 + 21),
        perCur=
          Buildings.Fluid.DXSystems.Heating.AirSource.Examples.PerformanceCurves.Curve_I())},
    final nSta=1,
    final QDefResCap=10500,
    final QCraCap=200,
    final defEIRFunT={0.297145,0.0430933,-0.000748766,0.00597727,0.000482112,-0.000956448},
    final PLFraFunPLR={1});
  annotation (defaultComponentName="datCoi",Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This record declares performance curves for the heating capacity and the EIR for use in
heating coil validation models in
<a href=\"modelica://Buildings.Fluid.DXSystems.Cooling.AirSource.Validation\">
Buildings.Fluid.DXSystems.Cooling.AirSource.Validation</a>.
It has been obtained from the EnergyPlus 9.6 example file
<code>PackagedTerminalHeatPump.idf</code>.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 19, 2023 by Xing Lu and Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"));
end SingleSpeedHeating;
