# frozen_string_literal: true

require 'rspec'
require_relative 'delivery_mechanism_spec_helper'

describe 'Finding a project' do
  let(:find_project_spy) { spy(execute: project) }
  let(:get_schema_spy) { spy(execute: schema) }

  before do
    stub_const(
      'HomesEngland::UseCase::FindProject',
      double(new: find_project_spy)
    )

    stub_const(
      'HomesEngland::UseCase::GetSchemaForProject',
      double(new: get_schema_spy)
    )

    get "/project/find?id=#{project_id}"
  end

  context 'with an non existant id' do
    let(:project_id) { 42 }
    let(:find_project_spy) { spy(execute: nil) }
    let(:get_schema_spy) { spy(execute: nil) }

    it 'should should return 404' do
      expect(last_response.status).to eq(404)
    end
  end

  context 'with an valid id' do
    context 'example one' do
      let(:project_id) { 42 }
      let(:project) { { type: 'cat', data: { cats_go: 'meow', dogs_go: 'woof' } } }
      let(:schema) {  { schema: { cats: 'go meow' } } }


      it 'should find the project with the given id' do
        expect(find_project_spy).to have_received(:execute).with(id: 42)
      end

      it 'should find the schema with the project type' do
        expect(get_schema_spy).to have_received(:execute).with(type: 'cat')
      end

      it 'should should return 200' do
        expect(last_response.status).to eq(200)
      end

      it 'should should have project in body with camel case' do
        response_body = JSON.parse(last_response.body)
        expect(response_body['type']).to eq('cat')
        expect(response_body['data']['catsGo']).to eq('meow')
        expect(response_body['data']['dogsGo']).to eq('woof')
      end

      it 'should should have schema in the return body' do
        response_body = JSON.parse(last_response.body)
        expect(response_body['schema']['cats']).to eq('go meow')
      end
    end

    context 'example two' do
      let(:project_id) { 41 }
      let(:project) { { type: 'animals', data: { animal_noises: [{ ducks_go: 'quack' }, { cows_go: 'moo' }] } } }
      let(:schema) { { schema: { dogs: 'bark', cats: 'meow' } } }

      let(:find_project_spy) { spy(execute: project) }

      it 'should find the project with the given id' do
        expect(find_project_spy).to have_received(:execute).with(id: 41)
      end

      it 'should find the schema with the project type' do
        expect(get_schema_spy).to have_received(:execute).with(type: 'animals')
      end

      it 'should should return 200' do
        expect(last_response.status).to eq(200)
      end

      it 'should should have project in body with camel case' do
        response_body = JSON.parse(last_response.body)
        expect(response_body['type']).to eq('animals')
        expect(response_body['data']['animalNoises'][0]['ducksGo']).to eq('quack')
        expect(response_body['data']['animalNoises'][1]['cowsGo']).to eq('moo')
      end

      it 'should should have schema in the return body' do
        response_body = JSON.parse(last_response.body)
        expect(response_body['schema']['dogs']).to eq('bark')
        expect(response_body['schema']['cats']).to eq('meow')
      end
    end
  end
end
