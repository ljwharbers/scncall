# helper-sim.R: shared simulated data sets for the test suite (built once per session).
# sim_small: tumour regime with multiplets; sim_flat: one flat cell type, no events, no multiplets.
sim_small = simulate_scn(n_cells = 160, seed = 11)
sim_flat = simulate_scn(n_cells = 120, seed = 12, multiplet_rate = 0, events = NULL, cell_types = c(normal = 1))
flat_cells = function(sim) sim$scn$cells$cell[!sim$truth$cells$multiplet & sim$scn$cells$cell_type == "normal"]
clean_cells = function(sim) sim$scn$cells$cell[!sim$truth$cells$multiplet]
