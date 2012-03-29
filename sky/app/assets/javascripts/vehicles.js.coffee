#= require lib/backbone-localstorage

$(document).ready () ->

  Vehicle = Backbone.Model.extend({

    defaults: { make: '', model: '', year: null, color: ''}

    localStorage: new Store("todos-backbone")

    clear: () ->
      this.destroy()

    action: () ->
      if this.isNew()
        'Create'
      else
        'Edit'
    })

  Vehicles = Backbone.Collection.extend({
    model: Vehicle,
    localStorage: new Store("todos-backbone"),
    clearAll: () ->

      try
        _.each this.models, (vehicle) ->
          vehicle.clear()
      catch err
        alert(err)

  })
  vehicles = new Vehicles

  VehicleEditView = Backbone.View.extend({
    template: Handlebars.compile($("#vehicle-edit-template").html())

    el: $('#edit-vehicles')

    save: () ->
      if this.model.isNew()
        vehicles.add(this.model)

      this.model.set({'make': $('#make').val(), model: $('#model').val(), year: $('#year').val(), color: $('#color').val()})
      this.model.save()

    render: () ->
      vehicle = this.model.toJSON()
      vehicle.action = this.model.action()
      this.$el.empty().fadeIn().append(this.template(vehicle))

      this.$el.find('#save-vehicle').on 'click', (e) =>
        e.preventDefault()
        this.save()
        this.$el.fadeOut()

  })


  VehicleView = Backbone.View.extend({
    initialize: () ->
      this.model.bind 'change', this.render, this
      this.model.bind 'destroy', this.remove, this

    events: {
      "click .vehicle-edit-link": "showForm"
      "click .vehicle-delete-link": "deleteVehicle"
    }

    template: Handlebars.compile($("#vehicle-template").html())


    render: () ->
      this.$el.html(this.template(this.model.toJSON()))
      this

    showForm: (e) ->
      e.preventDefault()
      new VehicleEditView({model: this.model}).render()

    deleteVehicle: (e) ->
      e.preventDefault()
      this.model.clear()
  })


  VehiclesView = Backbone.View.extend({

    load: () ->
      this.collection.bind('all', this.render, this);
      this.collection.fetch()

    el: $('#vehicles')

    render: () ->
      this.$el.empty()
      _.forEach this.collection.models, (vehicleData) =>
        vehicle = new Vehicle(vehicleData.toJSON())
        this.$el.append(new VehicleView({model: vehicle}).render().el)
  })

  new VehiclesView({collection: vehicles}).load()

  $('#new-vehicle').on 'click', (e) =>
    e.preventDefault();
    vehicle = new Vehicle
    new VehicleEditView({model: vehicle}).render()

  $('.vehicle-delete-link').live 'click', () ->
    return confirm('Are you sure?')


