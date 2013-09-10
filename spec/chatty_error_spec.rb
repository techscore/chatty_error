# coding: utf-8

require 'spec_helper'

describe ChattyError do
  describe '#included' do
    context 'methods defined' do
      it { expect(FooError.methods.include?(:configuration)).to be true }
      it { expect(FooError.methods.include?(:configuration=)).to be true }
      it { expect(FooError.methods.include?(:configure)).to be true }
      it { expect(FooError.methods.include?(:generate_key)).to be true }
      it { expect(FooError.methods.include?(:error_message)).to be true }
      it { expect(FooError.methods.include?(:caused_by)).to be true }
      it { expect(FooError.new.methods.include?(:cause)).to be true }
      it { expect(FooError.new.methods.include?(:cause=)).to be true }
    end
  end

  describe '#configure' do
    context 'return nil unless block_given' do
      it { expect(BarError.configure).to be nil}
    end

    context 'configure default scope' do
      before :all do
        BarError.configure do |config|
          config.default_scope = :other_scope
        end
      end

      it { expect(BarError.configuration.default_scope).to eq :other_scope }
    end

    context 'configure default message' do
      before :all do
        BarError.configure do |config|
          config.default_message = "error"
        end
      end

      it { expect(BarError.configuration.default_message).to eq "error" }
    end
  end

  describe '#configuration' do
    context 'inherit from parent' do
      it { expect(FooFooError.configuration.default_scope).to eq "fooooo" }
      it { expect(FooFooError.configuration.default_message).to eq "foo error" }
    end

    context 'configure' do
      it { expect(FooError.configuration.default_scope).to eq "fooooo" }
      it { expect(FooError.configuration.default_message).to eq "foo error" }
      it { expect(Foo2Error.configuration.default_scope).to eq "foo2" }
      it { expect(Foo2Error.configuration.default_message).to eq "foo2 error" }
    end
  end

  describe '#undercase' do
    it { expect(BazError.underscore('A')).to eq 'a' }
    it { expect(BazError.underscore('Abc')).to eq 'abc' }
    it { expect(BazError.underscore('AbcD')).to eq 'abc_d' }
    it { expect(BazError.underscore('AbcDef')).to eq 'abc_def' }
    it { expect(BazError.underscore('ABCD')).to eq 'abcd' }
    it { expect(BazError.underscore('ABcDe')).to eq 'a_bc_de' }
    it { expect(BazError.underscore('A::BCD')).to eq 'a.bcd' }
    it { expect(BazError.underscore('A::B::CD')).to eq 'a.b.cd' }
    it { expect(BazError.underscore('A::B::C::D')).to eq 'a.b.c.d' }
    it { expect(BazError.underscore('AAA::BBB::CCC::DDD')).to eq 'aaa.bbb.ccc.ddd' }
    it { expect(BazError.underscore('AaaBbb::CccDdd')).to eq 'aaa_bbb.ccc_ddd' }
  end

  describe '#generate_key' do
    it { expect(FooError.generate_key(FooError.name, :foo)).to eq 'foo_error.foo' }
    it { expect(BarError.generate_key(BarError.name, :bar)).to eq 'bar_error.bar' }
    it { expect(Boo::Error.generate_key(Boo::Error.name, :boo)).to eq 'boo.error.boo' }
    it { expect(Boo::Foo::Error.generate_key(Boo::Foo::Error.name, :boofoo)).to eq 'boo.foo.error.boofoo' }
    it { expect(Boo::Foo::Woo::Error.generate_key(Boo::Foo::Woo::Error.name, :boofoo_woo)).to eq 'boo.foo.woo.error.boofoo_woo' }
    it { expect(Boo::Foo::Woo::Error2.generate_key(Boo::Foo::Woo::Error2.name, :boofoo_woo)).to eq 'boo.foo.woo.error2.boofoo_woo' }
  end

  describe '#error_message' do
    context 'default configuration' do
      let (:default_error_message) { I18n.t('chatty_errors.default') }
      it { expect(HogeError.error_message(HogeError.name, :base)).to eq default_error_message }
      it { expect(HogeError.error_message(HogeError.name, :hoge1)).to eq default_error_message }
      it { expect(HogeError.error_message(HogeError.name, :hoge2)).to eq default_error_message }
    end

    context 'specific configuration' do
      context 'in yml' do
        it { expect(BaseError.error_message(BaseError.name, :base)).to eq I18n.t('chatty_errors.base_error.base') }
        it { expect(PiyoError.error_message(PiyoError.name, :piyopiyo)).to eq I18n.t('my_errors.piyo_error.piyopiyo') }

      end

      context 'not in yml' do
        it { expect(PiyoError.error_message(PiyoError.name, :piyopiyo2)).to eq 'p_error' }
      end
    end
  end

  describe '#caused_by' do
    context 'defined method' do
      it { expect(BaseError.methods.include?(:base)).to be true }
      it { expect(HogeError.methods.include?(:base)).to be true }
      it { expect(HogeError.methods.include?(:hoge1)).to be true }
      it { expect(HogeError.methods.include?(:hoge2)).to be true }
      it { expect(PiyoError.methods.include?(:piyopiyo)).to be true }
    end

    context 'initialize self instance' do
      it { expect(HogeError.base).to be_an_instance_of HogeError }
      it { expect(HogeError.hoge1).to be_an_instance_of HogeError }
      it { expect(HogeError.hoge2).to be_an_instance_of HogeError }

      it { expect(PiyoError.piyopiyo).to be_an_instance_of PiyoError }
    end

    context 'raise error' do
      it { expect{raise HogeError.base}.to raise_error(HogeError) }
      it { expect{raise HogeError.hoge1}.to raise_error(HogeError) }
      it { expect{raise HogeError.hoge2}.to raise_error(HogeError) }
      it { expect{raise PiyoError.piyopiyo}.to raise_error(PiyoError) }
    end

    context 'error message' do 
      it{ expect(BaseError.base.message).to eq I18n.t('chatty_errors.base_error.base') }
      it{ expect(HogeError.base.message).to eq I18n.t('chatty_errors.base_error.base') }
      it { expect(HogeError.hoge1.message).to eq I18n.t('chatty_errors.default') }
      it { expect(HogeError.hoge2.message).to eq I18n.t('chatty_errors.default') }
      it { expect(HogeHogeError.base.message).to eq I18n.t('chatty_errors.hoge_hoge_error.base') }
      it { expect(HogeHogeError.hoge1.message).to eq I18n.t('chatty_errors.default') }
      it { expect(HogeHogeError.hoge2.message).to eq I18n.t('chatty_errors.default') }
      it { expect(PiyoError.base.message).to eq I18n.t('my_errors.base_error.base') }
      it { expect(PiyoError.piyopiyo.message).to eq I18n.t('my_errors.piyo_error.piyopiyo') }
      it { expect(PiyoPiyoError.base.message).to eq I18n.t('my_errors.piyo_piyo_error.base') }
      it { expect(PiyoPiyoError.piyopiyo.message).to eq I18n.t('my_errors.piyo_error.piyopiyo') }
    end
  end
end
