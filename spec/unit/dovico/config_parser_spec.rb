require "helper"

module Dovico
  describe Dovico::ConfigParser do
    let(:config) { {} }

    subject do
      Dovico::ConfigParser.new(config)
    end

    describe "#date_options" do
      context 'with no date options' do
        let(:config) { {} }

        it 'returns nil, nil' do
          expect(subject.date_options).to eq([nil, nil])
        end
      end

      context 'with week option' do
        let(:config) { { week: 10, year: 2017 } }

        it 'returns first day of specified week, friday of the week' do
          expect(subject.date_options).to eq([Date.parse('2017-03-06'), Date.parse('2017-03-10')])
        end
      end

      context 'with day options' do
        let(:config) { { day: '2017-10-12' } }

        it 'returns specified date twice' do
          expect(subject.date_options).to eq([Date.parse('2017-10-12'), Date.parse('2017-10-12')])
        end
      end

      context 'with current_week options' do
        let(:config) { { current_week: true } }

        it 'returns monday, friday of the current week' do
          Timecop.freeze(Date.parse('2017-10-12')) do
            expect(subject.date_options).to eq([Date.parse('2017-10-09'), Date.parse('2017-10-13')])
          end
        end

        context 'with start and end options' do
          let(:config) { { start: '2017-10-12', end: '2017-12-13' } }

          it 'returns the provided dates' do
            expect(subject.date_options).to eq([Date.parse('2017-10-12'), Date.parse('2017-12-13')])
          end
        end
      end

      context 'with today options' do
        let(:config) { { today: true } }

        it 'returns current day twice' do
          Timecop.freeze(Date.parse('2017-10-22')) do
            expect(subject.date_options).to eq([Date.parse('2017-10-22'), Date.parse('2017-10-22')])
          end
        end
      end
    end

    describe '#needs_help?' do
      context 'with no config options' do
        let(:config) { {} }

        it 'returns true' do
          expect(subject.needs_help?).to be true
        end
      end

      context 'with --help' do
        let(:config) { { help: true } }

        it 'returns true' do
          expect(subject.needs_help?).to be true
        end
      end

      context 'with --fill and not date options' do
        let(:config) { { fill: true } }

        it 'returns true' do
          expect(subject.needs_help?).to be true
        end
      end

      context 'with --fill and date options' do
        let(:config) { { fill: true, week: 42 } }

        it 'returns false' do
          expect(subject.needs_help?).to be false
        end
      end
    end
  end
end
