describe HomesEngland::Gateway::SequelProject do
  include_context 'with database'

  let(:project_gateway) { described_class.new(database: database) }

  context 'updating a non existant project' do
    it 'returns unsuccessful' do
      project = HomesEngland::Domain::Project.new.tap do |p|
        p.type = 'Animals'
        p.data = { cats: 'meow' }
      end

      response = project_gateway.update(id: 123, project: project)

      expect(response).to eq(success: false)
    end
  end

  context 'example one' do
    let(:project) do
      HomesEngland::Domain::Project.new.tap do |p|
        p.type = 'Animals'
        p.data = { cats: 'meow' }
      end
    end
    let(:project_id) { project_gateway.create(project) }

    context 'creating the project' do
      it 'creates a new project' do
        created_project = project_gateway.find_by(id: project_id)

        expect(created_project.type).to eq('Animals')
        expect(created_project.data).to eq(cats: 'meow')
      end
    end

    context 'updating the project' do
      it 'updates the project' do
        project.data = { dogs: 'woof' }
        project_gateway.update(id: project_id, project: project)

        created_project = project_gateway.find_by(id: project_id)

        expect(created_project.type).to eq('Animals')
        expect(created_project.data).to eq(dogs: 'woof')
      end

      it 'returns successful' do
        project.data = { dogs: 'woof' }

        response = project_gateway.update(id: project_id, project: project)

        expect(response).to eq(success: true)
      end
    end
  end

  context 'example two' do
    let(:project) do
      HomesEngland::Domain::Project.new.tap do |p|
        p.type = 'FarmAnimals'
        p.data = {
          field: [
            { animal: 'cow', noise: 'moo' },
            { animal: 'sheep', noise: 'baa' }
          ],
          barn: []
        }
      end
    end
    let(:project_id) { project_gateway.create(project) }

    context 'creating a new project' do
      it 'creates a new project' do
        id = project_gateway.create(project)

        created_project = project_gateway.find_by(id: id)

        expect(created_project.type).to eq('FarmAnimals')
        expect(created_project.data).to eq(
          field: [
            { animal: 'cow', noise: 'moo' },
            { animal: 'sheep', noise: 'baa' }
          ],
          barn: []
        )
      end
    end

    context 'updating an existing project' do
      let(:project_id) { project_gateway.create(project) }

      it 'updates the project' do
        project.data[:barn] << { chicken: 'cluck' }

        project_gateway.update(id: project_id, project: project)

        created_project = project_gateway.find_by(id: project_id)

        expect(created_project.type).to eq('FarmAnimals')
        expect(created_project.data).to eq(
          field: [
            { animal: 'cow', noise: 'moo' },
            { animal: 'sheep', noise: 'baa' }
          ],
          barn: [{ chicken: 'cluck' }]
        )
      end

      it 'returns successful' do
        project.data[:barn] << { chicken: 'cluck' }

        response = project_gateway.update(id: project_id, project: project)

        expect(response).to eq(success: true)
      end
    end
  end
end

