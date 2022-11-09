within Buildings.Templates.ChilledWaterPlants.Components.Validation;
model RecordChillerGroup
  "Validation of parameter propagation with chiller group record"
  extends Modelica.Icons.Example;

  Buildings.Templates.ChilledWaterPlants.Components.Data.ChillerGroup dat(
    final nChi=2,
    final typChi=Buildings.Templates.Components.Types.Chiller.WaterCooled,
    final mChiWatChi_flow_nominal={30, 28},
    final mConWatChi_flow_nominal=fill(30, 2),
    final dpChiWatChi_nominal=fill(Buildings.Templates.Data.Defaults.dpChiWatChi, 2),
    final dpConChi_nominal=fill(Buildings.Templates.Data.Defaults.dpConWatChi, 2),
    final capChi_nominal=fill(1E6, 2),
    final TChiWatChiSup_nominal=fill(Buildings.Templates.Data.Defaults.TChiWatSup, 2),
    final TConWatChiEnt_nominal=fill(30+273.15,2),
    redeclare Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_Trane_CVHE_1442kW_6_61COP_VSD per(
      TConEnt_nominal=dat.TConWatChiEnt_nominal,
      TConEntMin=dat.TConChiEnt_min,
      TConEntMax=dat.TConChiEnt_max,
      QEva_flow_nominal={-1.4E6, -1.3E6},
      capFunT={
        {5.065247E-01,-4.158206E-03,-2.681976E-03,4.763436E-02,-1.951270E-03,3.994399E-03},
        {6.174861E-01,-7.299051E-02,-1.897105E-03,7.003662E-02,-2.852439E-03,5.751931E-03}},
      EIRFunT={
        {6.175311E-01,-3.913241E-02,6.177961E-04,2.775640E-02,-2.151466E-04,5.514895E-04},
        {6.931082E-01,-1.885558E-02,8.345461E-04,1.263879E-02,4.588028E-04,-8.221467E-04}},
      EIRFunPLR={
        {6.087656E-02,4.842164E-01,4.571519E-01},
        {1.040764E-01,2.818752E-01,6.144036E-01}}))
    "Chiller group record with overwriting of performance curves and default bindings"
    annotation (Placement(transformation(extent={{-10,-8},{10,12}})));

  annotation (Documentation(info="<html>
<p>
This model validates the parameter propagation within the record class
<a href=\"modelica://Buildings.Templates.ChilledWaterPlants.Components.Data.ChillerGroup\">
Buildings.Templates.ChilledWaterPlants.Components.Data.ChillerGroup</a>.
It illustrates
</p>
<ul>
<li>
the manual propagation of the nominal value of the condenser cooling
fluid temperature <code>TConEnt_nominal</code>
when redeclaring the performance data record <code>per</code>,
</li>
<li>
how the original bindings for other design parameters such as the 
CHW and CW flow rates persist when redeclaring the performance data record,
</li>
<li>
how to overwrite such persistent bindings if the nominal conditions
used to assess the performance data differ from the design conditions:
see the parameter binding for <code>QEva_flow_nominal</code>,
</li>
<li>
how different performance curves may be assigned to each chiller
inside the same group.
</li>
<ul>
</html>"));
end RecordChillerGroup;
