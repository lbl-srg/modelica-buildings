within Buildings.Templates.Plants.HeatPumps.Validation;
model HardCase1NLoadsCompliance
  "Validation of AWHP plant template with a distributed set of terminal loads"
  extends Buildings.Templates.Plants.HeatPumps.Validation.HardCase1NLoads(
    pla(use_cpl=true));
annotation(experiment(StopTime=86400,
  Tolerance=1e-06,
  __Dymola_Algorithm="Cvode"),
  Documentation(
    info="Model: Buildings.Templates.Plants.HeatPumps.Validation.HardCase1NLoadsCompliance
Integration started at 0 using integration method:
cvode from sundials

Warning: The following was detected at time: 27265.17065748617
  *** Warning in HardCase1NLoadsCompliance.loaHea[1].loa.coi: The flow direction reversed.
      However, because the constant use_dynamicFlowRegime is set to false,
      the model does not change equations based on the actual flow regime.
      To switch equations based on the actual flow regime during the simulation,
      set the constant use_dynamicFlowRegime=true.
      Note that this can lead to slow simulation because of events.
With: m_flow=-5.8983823812763
and    m_flow=12.315270935961
  Failed condition: noEvent(loaHea[1].loa.coi.m1_flow > -0.3734464627151052) and noEvent(loaHea[1].loa.coi.port_a2.m_flow > -1.2315270935960592)

Warning: The following was detected at time: 27265.17065748617
  *** Warning in HardCase1NLoadsCompliance.loaHea[2].loa.coi: The flow direction reversed.
      However, because the constant use_dynamicFlowRegime is set to false,
      the model does not change equations based on the actual flow regime.
      To switch equations based on the actual flow regime during the simulation,
      set the constant use_dynamicFlowRegime=true.
      Note that this can lead to slow simulation because of events.
With: m_flow=-5.8983824568698
and    m_flow=12.315270935961
  Failed condition: noEvent(loaHea[2].loa.coi.m1_flow > -0.3734464627151052) and noEvent(loaHea[2].loa.coi.port_a2.m_flow > -1.2315270935960592)

Warning: The following was detected at time: 27265.17065748617
  *** Warning in HardCase1NLoadsCompliance.loaHea[3].loa.coi: The flow direction reversed.
      However, because the constant use_dynamicFlowRegime is set to false,
      the model does not change equations based on the actual flow regime.
      To switch equations based on the actual flow regime during the simulation,
      set the constant use_dynamicFlowRegime=true.
      Note that this can lead to slow simulation because of events.
With: m_flow=-5.8983824575132
and    m_flow=12.315270935961
  Failed condition: noEvent(loaHea[3].loa.coi.m1_flow > -0.3734464627151052) and noEvent(loaHea[3].loa.coi.port_a2.m_flow > -1.2315270935960592)

Warning: The following was detected at time: 27265.17065748617
  *** Warning in HardCase1NLoadsCompliance.loaHea[4].loa.coi: The flow direction reversed.
      However, because the constant use_dynamicFlowRegime is set to false,
      the model does not change equations based on the actual flow regime.
      To switch equations based on the actual flow regime during the simulation,
      set the constant use_dynamicFlowRegime=true.
      Note that this can lead to slow simulation because of events.
With: m_flow=-5.8983824014593
and    m_flow=12.315270935961
  Failed condition: noEvent(loaHea[4].loa.coi.m1_flow > -0.3734464627151052) and noEvent(loaHea[4].loa.coi.port_a2.m_flow > -1.2315270935960592)

Warning: The following was detected at time: 27265.17065748617
  *** Warning in HardCase1NLoadsCompliance.loaHea[5].loa.coi: The flow direction reversed.
      However, because the constant use_dynamicFlowRegime is set to false,
      the model does not change equations based on the actual flow regime.
      To switch equations based on the actual flow regime during the simulation,
      set the constant use_dynamicFlowRegime=true.
      Note that this can lead to slow simulation because of events.
With: m_flow=-5.8983824683116
and    m_flow=12.315270935961
  Failed condition: noEvent(loaHea[5].loa.coi.m1_flow > -0.3734464627151052) and noEvent(loaHea[5].loa.coi.port_a2.m_flow > -1.2315270935960592)

Warning: The following was detected at time: 27265.17065748617
  *** Warning in HardCase1NLoadsCompliance.loaHea[6].loa.coi: The flow direction reversed.
      However, because the constant use_dynamicFlowRegime is set to false,
      the model does not change equations based on the actual flow regime.
      To switch equations based on the actual flow regime during the simulation,
      set the constant use_dynamicFlowRegime=true.
      Note that this can lead to slow simulation because of events.
With: m_flow=-5.89838240708
and    m_flow=12.315270935961
  Failed condition: noEvent(loaHea[6].loa.coi.m1_flow > -0.3734464627151052) and noEvent(loaHea[6].loa.coi.port_a2.m_flow > -1.2315270935960592)

Warning: The following was detected at time: 27265.17065748617
  *** Warning in HardCase1NLoadsCompliance.loaHea[7].loa.coi: The flow direction reversed.
      However, because the constant use_dynamicFlowRegime is set to false,
      the model does not change equations based on the actual flow regime.
      To switch equations based on the actual flow regime during the simulation,
      set the constant use_dynamicFlowRegime=true.
      Note that this can lead to slow simulation because of events.
With: m_flow=-5.8983823514359
and    m_flow=12.315270935961
  Failed condition: noEvent(loaHea[7].loa.coi.m1_flow > -0.3734464627151052) and noEvent(loaHea[7].loa.coi.port_a2.m_flow > -1.2315270935960592)

Warning: The following was detected at time: 27265.17065748617
  *** Warning in HardCase1NLoadsCompliance.loaHea[8].loa.coi: The flow direction reversed.
      However, because the constant use_dynamicFlowRegime is set to false,
      the model does not change equations based on the actual flow regime.
      To switch equations based on the actual flow regime during the simulation,
      set the constant use_dynamicFlowRegime=true.
      Note that this can lead to slow simulation because of events.
With: m_flow=-5.8983824465498
and    m_flow=12.315270935961
  Failed condition: noEvent(loaHea[8].loa.coi.m1_flow > -0.3734464627151052) and noEvent(loaHea[8].loa.coi.port_a2.m_flow > -1.2315270935960592)

Warning: The following was detected at time: 27265.17065748617
  *** Warning in HardCase1NLoadsCompliance.loaHea[9].loa.coi: The flow direction reversed.
      However, because the constant use_dynamicFlowRegime is set to false,
      the model does not change equations based on the actual flow regime.
      To switch equations based on the actual flow regime during the simulation,
      set the constant use_dynamicFlowRegime=true.
      Note that this can lead to slow simulation because of events.
With: m_flow=-5.8983823907011
and    m_flow=12.315270935961
  Failed condition: noEvent(loaHea[9].loa.coi.m1_flow > -0.3734464627151052) and noEvent(loaHea[9].loa.coi.port_a2.m_flow > -1.2315270935960592)

Warning: The following was detected at time: 27265.17065748617
  *** Warning in HardCase1NLoadsCompliance.loaHea[10].loa.coi: The flow direction reversed.
      However, because the constant use_dynamicFlowRegime is set to false,
      the model does not change equations based on the actual flow regime.
      To switch equations based on the actual flow regime during the simulation,
      set the constant use_dynamicFlowRegime=true.
      Note that this can lead to slow simulation because of events.
With: m_flow=-5.898382390457
and    m_flow=12.315270935961
  Failed condition: noEvent(loaHea[10].loa.coi.m1_flow > -0.3734464627151052) and noEvent(loaHea[10].loa.coi.port_a2.m_flow > -1.2315270935960592)

Warning: The following was detected at time: 27265.17065748617
  *** Warning in HardCase1NLoadsCompliance.loaHea[12].loa.coi: The flow direction reversed.
      However, because the constant use_dynamicFlowRegime is set to false,
      the model does not change equations based on the actual flow regime.
      To switch equations based on the actual flow regime during the simulation,
      set the constant use_dynamicFlowRegime=true.
      Note that this can lead to slow simulation because of events.
With: m_flow=-5.8983825207342
and    m_flow=12.315270935961
  Failed condition: noEvent(loaHea[12].port_a.m_flow > -0.3734464627151052) and noEvent(loaHea[12].loa.coi.port_a2.m_flow > -1.2315270935960592)

Warning: The following was detected at time: 27265.17065748617
  *** Warning in HardCase1NLoadsCompliance.loaHea[11].loa.coi: The flow direction reversed.
      However, because the constant use_dynamicFlowRegime is set to false,
      the model does not change equations based on the actual flow regime.
      To switch equations based on the actual flow regime during the simulation,
      set the constant use_dynamicFlowRegime=true.
      Note that this can lead to slow simulation because of events.
With: m_flow=-5.8983824444924
and    m_flow=12.315270935961
  Failed condition: noEvent(loaHea[11].loa.coi.m1_flow > -0.3734464627151052) and noEvent(loaHea[11].loa.coi.port_a2.m_flow > -1.2315270935960592)


Integration terminated successfully at T = 86400
   CPU-time for integration                  : 33.5166 seconds
   CPU-time for initialization               : 0.391439 seconds
   Number of result points                   : 1637
   Number of grid points                     : 501
   Number of accepted steps                  : 17935
   Number of rejected steps                  : 676
   Number of f-evaluations (dynamics)        : 27566
   Number of non-linear iteration            : 26355
   Number of non-linear convergence failures : 962
   Number of Jacobian-evaluations            : 1411
   Number of crossing function evaluations   : 20621
   Number of model time events               : 420
   Number of state events                    : 150
   Number of step events                     : 0
   Maximum integration order                 : 5

SUCCESSFUL simulation of Buildings.Templates.Plants.HeatPumps.Validation.HardCase1NLoadsCompliance",
    revisions="<html>
<ul>
<li>
September 18, 2026, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end HardCase1NLoadsCompliance;
